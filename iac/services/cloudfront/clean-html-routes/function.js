function handler(event) {
  var request = event.request;
  var uri = request.uri;
  var lastSegment = uri.substring(uri.lastIndexOf("/") + 1);

  if (uri !== "/" && uri.charAt(uri.length - 1) === "/") {
    request.uri = uri.slice(0, -1) + ".html";
  } else if (uri !== "/" && lastSegment.indexOf(".") === -1) {
    request.uri = uri + ".html";
  }

  return request;
}
