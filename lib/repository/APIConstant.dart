class APIConstant {
  // wafir 10.131.77.251
  static const String ipaddress = "http://192.168.0.115:8000/";
  // static const String ipaddress = "http://10.131.74.159:8000/";

  static const String URL = "${ipaddress}api/";

  // auth module
  static String get LoginURL => "${APIConstant.URL}login";
  static String get RegisterURL => "${APIConstant.URL}register";
  static String get LogoutURL => "${APIConstant.URL}logout";

  static String get ForgotPasswordURL =>
      "${APIConstant.URL}auth/forgot-password";

  // performance
  static String get PerformanceURL => "${APIConstant.URL}allPerformance";

  // refresh
  static String get RefreshURL => "${APIConstant.URL}refreshToken";

  // node
  static String get GetNodeListURL =>
      "${APIConstant.URL}getNodes"; // a list of nodes
  static String get AddNodeURL => "${APIConstant.URL}addNode"; // add a node

  // container
  static String get GetOneContainerURL =>
      "${APIConstant.URL}getOneContainer"; // must append with id
  static String get UpdateContainerURL =>
      "${APIConstant.URL}updateContainer"; // must append with id

  // http response
  static String get GetHttpResponsesURL =>
      "${APIConstant.URL}getHttpResponses"; // a list of nodes
  static String get DeleteNodeURL => "${APIConstant.URL}deleteNode";
  static String get SearchByCodeURL => "${APIConstant.URL}searchByCode";
  static String get SearchByDateURL => "${APIConstant.URL}searchByDate";

  // configs
  static String get GetConfigsURL => "${APIConstant.URL}getConfigs";
  static String get AddConfigURL => "${APIConstant.URL}addConfig";
  static String get UpdateConfigURL => "${APIConstant.URL}updateConfig";

  // node configs
  static String get GetNodeConfigsURL => "${APIConstant.URL}getNodeConfigs";
  static String get AddNodeConfigsURL => "${APIConstant.URL}addNodeConfig";
  static String get GetConfigByNodeURL => "${APIConstant.URL}getNodeConfig";

  // node access
  static String get GetNodeAccessesURL => "${APIConstant.URL}getNodeAccess";
  static String get AddNodeAccessURL => "${APIConstant.URL}addNodeAccess";
  static String get UpdateNodeAccessURL => "${APIConstant.URL}updateNodeAccess";
  static String get DeleteNodeAccessURL => "${APIConstant.URL}deleteNodeAccess";
  static String get GetAccessByNodeURL => "${APIConstant.URL}getNodeAccess";

  // user
  static String get GetUsersURL => "${APIConstant.URL}user";

  // role
  static String get GetRolesURL => "${APIConstant.URL}getRoles";

  // permission configs
  static String get GetPermissionsURL => "${APIConstant.URL}getPermissions";
  static String get AddPermissionURL => "${APIConstant.URL}addPermission";
  static String get UpdatePermissionURL => "${APIConstant.URL}updatePermission";

  // role permission
  static String get GetRolePermissionsURL =>
      "${APIConstant.URL}rolePermissions";
  static String get AddRolePermissionURL =>
      "${APIConstant.URL}addRolePermission";
  static String get DeleteNodePermissionURL =>
      "${APIConstant.URL}delRolePermission";

  // background process
  static String get GetBackgroundProcessURL => "${APIConstant.URL}getBpByService";
  static String get AddBackgroundProcessURL => "${APIConstant.URL}addBackgroundProcess";
  static String get DeleteBackgroundProcessURL => "${APIConstant.URL}deleteBackgroundProcess";

  // service
  static String get AddServiceURL => "${APIConstant.URL}addService";
  static String get GetServicesURL => "${APIConstant.URL}getServices";

  // node service
  static String get AddNodeServiceURL => "${APIConstant.URL}addNodeService";
  static String get DeleteNodeServiceURL => "${APIConstant.URL}deleteNodeService";


}
