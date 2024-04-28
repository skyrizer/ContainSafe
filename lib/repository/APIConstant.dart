class APIConstant {
  // yunghuey
  static const String ipaddress = "http://192.168.0.115:8000/";
  // wafir
  // static const String ipaddress = "http://10.131.151.180:45455/";
  static const String URL = "${ipaddress}api/";

  // auth module
  static String get LoginURL => "${APIConstant.URL}login";
  static String get RefreshURL => "${APIConstant.URL}auth/refresh";
  static String get RegisterURL => "${APIConstant.URL}auth/register";
  static String get ForgotPasswordURL =>
      "${APIConstant.URL}auth/forgot-password";
  static String get LogoutURL => "${APIConstant.URL}auth/logout";

}
