import 'dart:convert';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/nodeConfig/nodeConfig.dart';
import '../model/rolePermission/rolePermission.dart';

class RolePermissionRepository {

  Future<List<RolePermission>> getAllRolePermissions() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      print(token);
      var url = Uri.parse(APIConstant.GetNodeConfigsURL);  ///
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        Map<String, dynamic> rolePermissionsData = responseData['rolePermissions'];

        List<RolePermission> rolePermissions = [];
        rolePermissionsData.forEach((key, value) {
          List<dynamic> rPsData = value;
          rPsData.forEach((rPData) {
            RolePermission rolePermission = RolePermission.fromJson(rPData);
            rolePermissions.add(rolePermission);
          });
        });

        return rolePermissions;
      }
      else {
        print("Failed to load nodes. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in getting all nodes: $e");
      return [];
    }
  }

  Future<int> addRolePermission(int roleId, int permissionId) async{
    var pref = await SharedPreferences.getInstance();
    try{

      String? token = pref.getString("token");

      var url = Uri.parse(APIConstant.AddNodeConfigsURL);  /////

      var body = json.encode({
        "role_id": roleId,
        "permission_id": permissionId,
      });

      print(body.toString());
      var response = await http.post(url,
          headers: {"Content-Type": "application/json","Authorization": "Bearer ${token}"},
          body: body
      );

      if (response.statusCode == 200){
        // String data =  response.body;
        // pref.setString("token", data);
        return 0;
      }
      else {
        return 3;
      }


    } catch (e) {
      print('error in add role permission');
      print(e.toString());
      return 3;
    }
  }

  // delete node access
  Future<bool> deleteRolePermission(int roleId, int permissionId) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.DeleteNodeAccessURL + "/${roleId.toString()}/${permissionId.toString()}");  /// url
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.delete(url, headers: header);
      if (response.statusCode == 200){

        return true;
      }else{
        return false;
      }

    } catch (e){
      print("error to delete role permission ${e.toString()}");
      return false;
    }
  }



}