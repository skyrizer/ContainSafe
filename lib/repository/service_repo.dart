import 'dart:convert';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/node/node.dart';
import '../model/role/role.dart';

class ServiceRepository {


  Future<int> addService(String name) async{
    var pref = await SharedPreferences.getInstance();
    try{

      String? token = pref.getString("token");

      var url = Uri.parse(APIConstant.AddServiceURL);  //dsfdfdsf

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
      print('error in add service');
      print(e.toString());
      return 3;
    }
  }

  // Future<bool> updateRole(Role role) async {
  //   try {
  //     var pref = await SharedPreferences.getInstance();
  //     String? token = pref.getString("token");
  //
  //     if (token!.isNotEmpty) {
  //       var url = Uri.parse(APIConstant.UpdateConfigURL+"/${role.id}");  // take note
  //       print(url);
  //       var header = {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer ${token}",
  //       };
  //       var body = json.encode({
  //         "role": role.role,
  //
  //       });
  //       var response = await http.put(url, headers: header, body: body);
  //
  //       if (response.statusCode == 200) {
  //         return true;
  //       } else {
  //         print("response fail: ${response.statusCode}");
  //         print("response fail: ${response.body}");
  //       }
  //     }
  //     return false;
  //   } catch (e) {
  //     print("error in updating user ${e.toString()}");
  //     return false;
  //   }
  // }



}