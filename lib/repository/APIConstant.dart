class APIConstant {

  // wafir 10.131.77.251
   static const String ipaddress = "http://192.168.0.115:8000/";
  // static const String ipaddress = "http://10.131.77.251:8000/";


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
  static String get RefreshURL => "${APIConstant.URL}refreshToken";

  // node
  static String get GetNodeListURL => "${APIConstant.URL}getNodes";   // a list of nodes
  static String get AddNodeURL => "${APIConstant.URL}addNode";   // add a node

  // container
  static String get GetOneContainerURL => "${APIConstant.URL}getOneContainer";    // must append with id
  static String get UpdateContainerURL => "${APIConstant.URL}updateContainer";    // must append with id

  // http response
  static String get GetHttpResponsesURL => "${APIConstant.URL}getHttpResponses";   // a list of nodes
  static String get DeleteNodeURL => "${APIConstant.URL}deleteNode";

  // configs
   static String get GetConfigsURL => "${APIConstant.URL}getConfigs";
   static String get AddConfigURL => "${APIConstant.URL}addConfig";
   static String get UpdateConfigURL => "${APIConstant.URL}updateConfig";


   // node configs
   static String get GetNodeConfigsURL => "${APIConstant.URL}getNodeConfigs";
   static String get AddNodeConfigsURL => "${APIConstant.URL}addNodeConfig";
   static String get GetConfigByNodeURL => "${APIConstant.URL}getNodeConfig";


   // permission configs
   static String get GetPermissionsURL => "${APIConstant.URL}getPermissions";
   static String get AddPermissionURL => "${APIConstant.URL}addPermission";
   static String get UpdatePermissionURL => "${APIConstant.URL}updatePermission";










}
