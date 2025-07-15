class NetworkUtils {
  NetworkUtils._();

  static const geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp-image-generation:generateContent?key=";
  static const temperature = 1.5;
  static const mimeType = "image/jpeg";
  static const topK = 40;
  static const topP = 0.95;
  static const maxOutputTokens = 8192;
  static const responseModality = ["image", "text"];
}

class NetworkStatusCode {
  // Success
  static const int status200 = 200; // OK
  static const int status201 = 201; // Created
  static const int status204 = 204; // No Content

  // Client errors
  static const int status400 = 400; // Bad Request
  static const int status401 = 401; // Unauthorized
  static const int status403 = 403; // Forbidden
  static const int status404 = 404; // Not Found
  static const int status409 = 409; // Conflict

  // Server errors
  static const int status500 = 500; // Internal Server Error
  static const int status502 = 502; // Bad Gateway
  static const int status503 = 503; // Service Unavailable
  static const int status504 = 504; // Gateway Timeout
}
