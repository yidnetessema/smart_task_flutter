class Endpoints {
  // static String baseEndPoint = "http://172.28.0.40:8080/app-services";
  static String baseEndPoint = "http://localhost:8081/api/v1";

  static Uri login = Uri.parse("${baseEndPoint}/auth/login");
  static Uri register = Uri.parse("${baseEndPoint}/api/v1/auth/register");
  static Uri verifyEmail = Uri.parse("${baseEndPoint}/api/v1/auth/verify-email");
  static Uri verifyEmailOtp = Uri.parse("${baseEndPoint}/api/v1/auth/verify-email-otp");

  static Uri appUser = Uri.parse("${baseEndPoint}/api/app-user");
  static Uri appUserCore = Uri.parse("${baseEndPoint}/api/core/app-user");
  static Uri securityQuestionRandom = Uri.parse("${baseEndPoint}/api/core/app/user/security-question/random?amount=6");
  static Uri getMyAccounts = Uri.parse("${baseEndPoint}/api/core/app/user/account");
  static Uri accountManager = Uri.parse("${baseEndPoint}/api/core/app/user/account/manager");
  static Uri initiateC2CTransaction = Uri.parse("${baseEndPoint}/api/core/app/apis/open-c2c");
  static Uri selfTransfer = Uri.parse("${baseEndPoint}/api/core/app/apis/transfer");
  static Uri transactions = Uri.parse("${baseEndPoint}/api/core/app/user/transactions");
}