import 'dart:convert';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NodeServiceRepository {


  Future<int> addNodeService(int serviceId, int nodeId) async{
    var pref = await SharedPreferences.getInstance();
    try{

      String? token = pref.getString("token");

      var url = Uri.parse(APIConstant.AddNodeServiceURL);   /// take note

      var body = json.encode({
        "service_id": serviceId,
        "node_id": nodeId
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
      print('error in add node service');
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
  Future<bool> deleteNodeService(int nodeId, int serviceId) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.DeleteNodeServiceURL + "/${nodeId.toString()}/${serviceId.toString()}");  /// url
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
      print("error to delete node service ${e.toString()}");
      return false;
    }
  }

}