class ApiExceptionHandler {
  static String getErrorMessage(dynamic e) {
    if (e.toString().contains("SocketException")) {
      return "No internet connection.";
    }

    if (e.toString().contains("TimeoutException")) {
      return "Server not responding, please try again.";
    }

    return "Something went wrong, please try again.";
  }
}
