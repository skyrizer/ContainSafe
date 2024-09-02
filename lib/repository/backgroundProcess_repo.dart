import 'dart:convert';
import 'package:containsafe/model/backgroundProcess/backgroundProcess.dart';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/nodeAccess/nodeAccess.dart';

class BackgroundProcessRepository {

  Future<List<BackgroundProcess>> getBpByService(int serviceId) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      print(token);
      var url = Uri.parse(APIConstant.GetBackgroundProcessURL+"/${serviceId}");   ////  update plis
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {

        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> jsonData = responseData['backgroundProcesses']; // Accessing the 'backgroundService' key

        List<BackgroundProcess> backgroundProcesses = jsonData.map((data) => BackgroundProcess.fromJson(data)).toList();


        return backgroundProcesses;
      }
      else {
        print("Failed to load background processes. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in getting all node access: $e");
      return [];
    }
  }


  Future<int> addBackgroundProcess(String name,int serviceId) async{
    var pref = await SharedPreferences.getInstance();
    try{

      String? token = pref.getString("token");

      var url = Uri.parse(APIConstant.AddBackgroundProcessURL);   /// take note

      var body = json.encode({
        "name": name,
        "service_id": serviceId
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
      print('error in add background process');
      print(e.toString());
      return 3;
    }
  }

  // Future<bool> updateNodeAccess(NodeAccess nodeAccess) async {
  //   try {
  //     var pref = await SharedPreferences.getInstance();
  //     String? token = pref.getString("token");
  //
  //     if (token!.isNotEmpty) {
  //       var url = Uri.parse(APIConstant.UpdateNodeAccessURL+"/${nodeAccess.id}");  // take note
  //       print(url);
  //       var header = {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer ${token}",
  //       };
  //       var body = json.encode({
  //         "role_id": nodeAccess.roleId,
  //         "user_id": nodeAccess.userId,
  //         "node_id": nodeAccess.nodeId
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
  //     print("error in updating permission ${e.toString()}");
  //     return false;
  //   }
  // }


  // delete node access
  Future<bool> DeleteBackgroundProcess(int serviceId, int bpId) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.DeleteBackgroundProcessURL + "/${serviceId.toString()}" + "/${bpId.toString()}");  /// url
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
      print("error to delete background process ${e.toString()}");
      return false;
    }
  }

}