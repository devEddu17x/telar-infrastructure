"use strict";

const crypto = require("crypto");

const INTERNAL_SECRET_KEY = "x-internal-secret";

/**
 * Compara dos cadenas en tiempo constante para prevenir ataques de tiempo.
 * @param {string} a
 * @param {string} b
 * @returns {boolean}
 */
function safeCompare(a, b) {
  const aBuf = Buffer.from(a);
  const bBuf = Buffer.from(b);
  if (aBuf.length !== bBuf.length) {
    return false;
  }
  return crypto.timingSafeEqual(aBuf, bBuf);
}

/**
 * @param {import('aws-lambda').PreSignUpTriggerEvent} event
 * @returns {Promise<import('aws-lambda').PreSignUpTriggerEvent>}
 */
exports.handler = async (event) => {
  const expectedSecret = process.env.SIGNUP_INTERNAL_SECRET;

  if (!expectedSecret) {
    console.error("[pre-sign-up] SIGNUP_INTERNAL_SECRET env var is not set");
    throw new Error("Internal configuration error");
  }

  const clientMetadata = event.request.clientMetadata || {};
  const receivedSecret = clientMetadata[INTERNAL_SECRET_KEY];

  if (!receivedSecret) {
    console.warn("[pre-sign-up] Rejected: missing internal secret in clientMetadata");
    throw new Error("Unauthorized: missing internal secret");
  }

  if (!safeCompare(receivedSecret, expectedSecret)) {
    console.warn("[pre-sign-up] Rejected: internal secret mismatch");
    throw new Error("Unauthorized: invalid internal secret");
  }

  console.info(`[pre-sign-up] Approved signup for: ${event.request.userAttributes?.email ?? "unknown"}`);

  event.response.autoConfirmUser = false;
  event.response.autoVerifyEmail = false;

  return event;
};
