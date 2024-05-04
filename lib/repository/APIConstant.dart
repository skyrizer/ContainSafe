class APIConstant {

  // wafir
  static const String ipaddress = "http://192.168.0.115:8000/";

  static const String URL = "${ipaddress}api/";

  // auth module
  static String get LoginURL => "${APIConstant.URL}login";
  // not functioning yet
  static String get RegisterURL => "${APIConstant.URL}auth/register";
  static String get ForgotPasswordURL =>
      "${APIConstant.URL}auth/forgot-password";
  static String get LogoutURL => "${APIConstant.URL}auth/logout";

  // performance
  static String get PerformanceURL => "${APIConstant.URL}allPerformance";

  // refresh
  static String get RefreshURL => "${APIConstant.URL}//refreshToken";

  // node
  static String get GetNodeListURL => "${APIConstant.URL}getNodes";   // a list of nodes





}
