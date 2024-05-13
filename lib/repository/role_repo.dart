import 'dart:convert';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/node/node.dart';
import '../model/role/role.dart';

class RoleRepository {

  Future<List<Role>> getAllRoles() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      print(token);
      var url = Uri.parse(APIConstant.GetRolesURL);
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> jsonData = responseData['roles']; // Accessing the 'nodes' key

        List<Role> roles = jsonData.map((data) => Role.fromJson(data)).toList();

        return roles;
      } else {
        print("Failed to load nodes. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in getting all roles: $e");
      return [];
    }
  }

  Future<int> addRole(String role) async{
    var pref = await SharedPreferences.getInstance();
    try{

      String? token = pref.getString("token");

      var url = Uri.parse(APIConstant.AddNodeURL);  //dsfdfdsf

      var body = json.encode({
        "role": role,

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
      print('error in add role');
      print(e.toString());
      return 3;
    }
  }

  Future<bool> updateRole(Role role) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");

      if (token!.isNotEmpty) {
        var url = Uri.parse(APIConstant.UpdateConfigURL+"/${role.id}");  // take note
        print(url);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var body = json.encode({
          "role": role.role,

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
      print("error in updating user ${e.toString()}");
      return false;
    }
  }



}