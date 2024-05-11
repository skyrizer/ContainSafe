import 'dart:convert';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/node/node.dart';
import '../model/permission/permission.dart';
import '../model/role/role.dart';

class PermissionRepository {

  Future<List<Permission>> getAllPermissions() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      print(token);
      var url = Uri.parse(APIConstant.GetPermissionsURL);  ////
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> jsonData = responseData['permissions']; // Accessing the 'nodes' key

        List<Permission> permissions = jsonData.map((data) => Permission.fromJson(data)).toList();

        return permissions;
      } else {
        print("Failed to load permissions. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in getting all permissions: $e");
      return [];
    }
  }

  Future<int> addPermission(String name) async{
    var pref = await SharedPreferences.getInstance();
    try{

      String? token = pref.getString("token");

      var url = Uri.parse(APIConstant.AddNodeURL);  //dsfdfdsf

      var body = json.encode({
        "name": name,

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
      print('error in add permission');
      print(e.toString());
      return 3;
    }
  }

  Future<bool> updatePermission(Permission permission) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");

      if (token!.isNotEmpty) {
        var url = Uri.parse(APIConstant.UpdateConfigURL+"/${permission.id}");  // take note
        print(url);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var body = json.encode({
          "name": permission.name,

        });
        var response = await http.put(url, headers: header, body: body);

        if (response.statusCode == 200) {
          return true;
        } else {
          print("response fail: ${response.statusCode}");
          print("response fail: ${response.body}");
        }
      }
      return false;
    } catch (e) {
      print("error in updating permission ${e.toString()}");
      return false;
    }
  }



}