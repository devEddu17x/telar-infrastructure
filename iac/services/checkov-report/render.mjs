import { readFile, writeFile, mkdir } from "node:fs/promises";

const [, , inputPath, outputDir = "checkov-report", requestedMode = process.env.CHECKOV_REPORT_MODE ?? "detailed"] =
  process.argv;
const mode = ["summary", "detailed"].includes(requestedMode) ? requestedMode : "detailed";

if (!inputPath) {
  console.error("Usage: node render.mjs <junit-xml-path> [output-dir] [summary|detailed]");
  process.exit(1);
}

const xml = await readFile(inputPath, "utf8");
const suites = parseSuites(xml);
const totals = suites.reduce(
  (acc, suite) => ({
    tests: acc.tests + suite.tests,
    failures: acc.failures + suite.failures,
    errors: acc.errors + suite.errors,
    skipped: acc.skipped + suite.skipped,
    time: acc.time + suite.time,
  }),
  { tests: 0, failures: 0, errors: 0, skipped: 0, time: 0 },
);

const failedCases = suites
  .flatMap((suite) => suite.cases.map((testCase) => ({ ...testCase, suite: suite.name })))
  .filter((testCase) => testCase.status !== "passed");

const context = readContext();
const status = totals.failures > 0 || totals.errors > 0 ? "Action required" : "Passed";
const subject = `[Checkov] ${mode === "summary" ? "Summary" : "Report"} ${status}: ${totals.failures} failures, ${totals.errors} errors, ${totals.skipped} skipped`;
const text = mode === "summary" ? renderSummaryText({ context, totals }) : renderText({ context, totals, failedCases });
const html =
  mode === "summary"
    ? renderSummaryHtml({ context, totals, status })
    : renderDetailedHtml({ context, totals, failedCases, status });

await mkdir(outputDir, { recursive: true });
await writeFile(`${outputDir}/subject.txt`, subject);
await writeFile(`${outputDir}/body.txt`, text);
await writeFile(`${outputDir}/body.html`, html);
await writeFile(
  `${outputDir}/summary.json`,
  JSON.stringify({ subject, mode, totals, failedCases: failedCases.length, context }, null, 2),
);

function parseSuites(source) {
  const suiteMatches = [...source.matchAll(/<testsuite\b([^>]*)>([\s\S]*?)<\/testsuite>/g)];
  const suitesToParse = suiteMatches.length > 0 ? suiteMatches : [[null, "", source]];

  return suitesToParse.map((match) => {
    const attrs = parseAttributes(match[1] ?? "");
    const body = match[2] ?? "";
    const cases = [...body.matchAll(/<testcase\b([^>]*?)(?:\/>|>([\s\S]*?)<\/testcase>)/g)].map((caseMatch) => {
      const caseAttrs = parseAttributes(caseMatch[1] ?? "");
      const caseBody = caseMatch[2] ?? "";
      const failure = firstTag(caseBody, "failure");
      const error = firstTag(caseBody, "error");
      const skipped = firstTag(caseBody, "skipped");
      const status = error ? "error" : failure ? "failure" : skipped ? "skipped" : "passed";

      return {
        name: decodeXml(caseAttrs.name ?? "Unnamed check"),
        classname: decodeXml(caseAttrs.classname ?? ""),
        file: decodeXml(caseAttrs.file ?? ""),
        status,
        message: decodeXml((error ?? failure ?? skipped)?.attrs.message ?? ""),
        details: cleanDetails(decodeXml((error ?? failure ?? skipped)?.body ?? "")),
      };
    });

    return {
      name: decodeXml(attrs.name ?? "Checkov"),
      tests: numberAttr(attrs.tests, cases.length),
      failures: numberAttr(attrs.failures, cases.filter((testCase) => testCase.status === "failure").length),
      errors: numberAttr(attrs.errors, cases.filter((testCase) => testCase.status === "error").length),
      skipped: numberAttr(attrs.skipped, cases.filter((testCase) => testCase.status === "skipped").length),
      time: numberAttr(attrs.time, 0),
      cases,
    };
  });
}

function parseAttributes(source) {
  const attrs = {};
  for (const match of source.matchAll(/([\w:-]+)="([^"]*)"/g)) {
    attrs[match[1]] = match[2];
  }
  return attrs;
}

function firstTag(source, tagName) {
  const match = source.match(new RegExp(`<${tagName}\\b([^>]*)>([\\s\\S]*?)<\\/${tagName}>|<${tagName}\\b([^>]*)\\/>`));
  if (!match) return null;
  return {
    attrs: parseAttributes(match[1] ?? match[3] ?? ""),
    body: match[2] ?? "",
  };
}

function decodeXml(value) {
  return String(value)
    .replaceAll("&quot;", '"')
    .replaceAll("&apos;", "'")
    .replaceAll("&lt;", "<")
    .replaceAll("&gt;", ">")
    .replaceAll("&amp;", "&");
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

function numberAttr(value, fallback) {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : fallback;
}

function cleanDetails(value) {
  return value.replace(/\n{3,}/g, "\n\n").trim();
}

function readContext() {
  return {
    repository: process.env.GITHUB_REPOSITORY ?? "local",
    ref: process.env.GITHUB_HEAD_REF || process.env.GITHUB_REF_NAME || process.env.GITHUB_REF || "local",
    baseRef: process.env.GITHUB_BASE_REF ?? "",
    event: process.env.GITHUB_EVENT_NAME ?? "local",
    actor: process.env.GITHUB_ACTOR ?? "local",
    runUrl:
      process.env.GITHUB_SERVER_URL && process.env.GITHUB_REPOSITORY && process.env.GITHUB_RUN_ID
        ? `${process.env.GITHUB_SERVER_URL}/${process.env.GITHUB_REPOSITORY}/actions/runs/${process.env.GITHUB_RUN_ID}`
        : "",
    sha: process.env.GITHUB_SHA ?? "",
  };
}

function renderSummaryText({ context, totals }) {
  return [
    "Checkov summary",
    "",
    "A new pull request update was scanned. This email only includes totals to keep PR notifications lightweight.",
    "",
    `Repository: ${context.repository}`,
    `Ref: ${context.ref}`,
    context.baseRef ? `Base: ${context.baseRef}` : "",
    `Event: ${context.event}`,
    context.runUrl ? `Run: ${context.runUrl}` : "",
    "",
    `Tests: ${totals.tests}`,
    `Failures: ${totals.failures}`,
    `Errors: ${totals.errors}`,
    `Skipped: ${totals.skipped}`,
    "",
  ]
    .filter(Boolean)
    .join("\n");
}

function renderText({ context, totals, failedCases }) {
  const lines = [
    "Checkov report",
    "",
    `Repository: ${context.repository}`,
    `Ref: ${context.ref}`,
    `Event: ${context.event}`,
    context.runUrl ? `Run: ${context.runUrl}` : "",
    "",
    `Tests: ${totals.tests}`,
    `Failures: ${totals.failures}`,
    `Errors: ${totals.errors}`,
    `Skipped: ${totals.skipped}`,
    "",
  ].filter(Boolean);

  for (const testCase of failedCases.slice(0, 40)) {
    lines.push(`- [${testCase.status}] ${testCase.name}`);
    if (testCase.classname) lines.push(`  ${testCase.classname}`);
    if (testCase.message) lines.push(`  ${testCase.message}`);
  }

  if (failedCases.length > 40) {
    lines.push(``, `Showing 40 of ${failedCases.length} non-passing checks.`);
  }

  return `${lines.join("\n")}\n`;
}

function renderDetailedHtml({ context, totals, failedCases, status }) {
  const rows = failedCases
    .slice(0, 80)
    .map(
      (testCase) => `
        <tr>
          <td><span class="badge ${escapeHtml(testCase.status)}">${escapeHtml(testCase.status)}</span></td>
          <td>
            <strong>${escapeHtml(testCase.name)}</strong>
            <div class="muted">${escapeHtml(testCase.classname || testCase.suite)}</div>
            ${testCase.message ? `<div>${escapeHtml(testCase.message)}</div>` : ""}
            ${testCase.details ? `<pre>${escapeHtml(testCase.details)}</pre>` : ""}
          </td>
        </tr>`,
    )
    .join("");

  return `<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Checkov Report</title>
    <style>
      body { margin: 0; background: #f6f8fb; color: #172033; font-family: Arial, sans-serif; }
      .wrap { max-width: 920px; margin: 0 auto; padding: 28px; }
      .panel { background: #ffffff; border: 1px solid #d9e0ea; border-radius: 8px; overflow: hidden; }
      .header { padding: 24px; background: #172033; color: #ffffff; }
      .header h1 { margin: 0 0 8px; font-size: 22px; }
      .header p { margin: 0; color: #c8d2e2; }
      .metrics { display: grid; grid-template-columns: repeat(4, 1fr); border-bottom: 1px solid #d9e0ea; }
      .metric { padding: 18px; border-right: 1px solid #d9e0ea; }
      .metric:last-child { border-right: 0; }
      .metric b { display: block; font-size: 24px; margin-bottom: 4px; }
      .metric span, .muted { color: #657083; font-size: 12px; }
      .content { padding: 22px; }
      table { width: 100%; border-collapse: collapse; }
      td { padding: 14px 10px; border-top: 1px solid #e7ebf1; vertical-align: top; }
      pre { white-space: pre-wrap; background: #f1f4f8; border-radius: 6px; padding: 10px; color: #334155; font-size: 12px; }
      .badge { display: inline-block; min-width: 56px; padding: 5px 8px; border-radius: 999px; color: #fff; font-size: 11px; text-align: center; text-transform: uppercase; }
      .failure { background: #c2410c; }
      .error { background: #b91c1c; }
      .skipped { background: #64748b; }
      .footer { padding: 18px 22px; background: #f8fafc; color: #657083; font-size: 12px; }
      a { color: #2563eb; }
      @media (max-width: 700px) { .metrics { grid-template-columns: repeat(2, 1fr); } .wrap { padding: 12px; } }
    </style>
  </head>
  <body>
    <div class="wrap">
      <div class="panel">
        <div class="header">
          <h1>Checkov ${escapeHtml(status)}</h1>
          <p>${escapeHtml(context.repository)} · ${escapeHtml(context.ref)} · ${escapeHtml(context.event)}</p>
        </div>
        ${renderMetricsHtml(totals)}
        <div class="content">
          <p>This detailed Checkov report was generated after changes reached a tracked branch.</p>
          <p>Review each non-passing check below and prioritize failures or errors before the next deployment window.</p>
          ${
            failedCases.length
              ? `<table>${rows}</table>`
              : `<p>No failures, errors, or skipped checks were reported.</p>`
          }
        </div>
        <div class="footer">
          ${context.runUrl ? `<a href="${escapeHtml(context.runUrl)}">Open GitHub Actions run</a>` : "Generated locally"}
          ${failedCases.length > 80 ? ` · Showing 80 of ${failedCases.length} non-passing checks` : ""}
        </div>
      </div>
    </div>
  </body>
</html>`;
}

function renderSummaryHtml({ context, totals, status }) {
  return `<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Checkov Summary</title>
    <style>
      body { margin: 0; background: #f6f8fb; color: #172033; font-family: Arial, sans-serif; }
      .wrap { max-width: 760px; margin: 0 auto; padding: 28px; }
      .panel { background: #ffffff; border: 1px solid #d9e0ea; border-radius: 8px; overflow: hidden; }
      .header { padding: 24px; background: #172033; color: #ffffff; }
      .header h1 { margin: 0 0 8px; font-size: 22px; }
      .header p { margin: 0; color: #c8d2e2; }
      .metrics { display: grid; grid-template-columns: repeat(4, 1fr); border-bottom: 1px solid #d9e0ea; }
      .metric { padding: 18px; border-right: 1px solid #d9e0ea; }
      .metric:last-child { border-right: 0; }
      .metric b { display: block; font-size: 30px; margin-bottom: 4px; }
      .metric span, .muted { color: #657083; font-size: 12px; }
      .content { padding: 22px; line-height: 1.5; }
      .footer { padding: 18px 22px; background: #f8fafc; color: #657083; font-size: 12px; }
      a { color: #2563eb; }
      @media (max-width: 700px) { .metrics { grid-template-columns: repeat(2, 1fr); } .wrap { padding: 12px; } }
    </style>
  </head>
  <body>
    <div class="wrap">
      <div class="panel">
        <div class="header">
          <h1>Checkov Summary: ${escapeHtml(status)}</h1>
          <p>${escapeHtml(context.repository)} · ${escapeHtml(context.ref)}${context.baseRef ? ` → ${escapeHtml(context.baseRef)}` : ""}</p>
        </div>
        ${renderMetricsHtml(totals)}
        <div class="content">
          <p>Checkov completed a security scan for this pull request update.</p>
          <p>Review the totals below to understand the current infrastructure compliance status before merging.</p>
          <p>The complete JUnit XML report is attached to the GitHub Actions run as an artifact for deeper review.</p>
        </div>
        <div class="footer">
          ${context.runUrl ? `<a href="${escapeHtml(context.runUrl)}">Open GitHub Actions run</a>` : "Generated locally"}
        </div>
      </div>
    </div>
  </body>
</html>`;
}

function renderMetricsHtml(totals) {
  return `<div class="metrics">
          <div class="metric"><b>${totals.tests}</b><span>Tests</span></div>
          <div class="metric"><b>${totals.failures}</b><span>Failures</span></div>
          <div class="metric"><b>${totals.errors}</b><span>Errors</span></div>
          <div class="metric"><b>${totals.skipped}</b><span>Skipped</span></div>
        </div>`;
}
