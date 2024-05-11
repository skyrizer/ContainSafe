import 'dart:convert';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/nodeAccess/nodeAccess.dart';

class NodeAccessRepository {

  Future<List<NodeAccess>> getAllNodeAccesses() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.GetNodeConfigsURL);   ///  take note
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        Map<String, dynamic> nodeAccessesData = responseData['nodeAccesses'];

        List<NodeAccess> nodeAccesses = [];
        nodeAccessesData.forEach((key, value) {
          List<dynamic> accessesData = value;
          accessesData.forEach((accessData) {
            NodeAccess nodeAccess = NodeAccess.fromJson(accessData);
            nodeAccesses.add(nodeAccess);
          });
        });

        return nodeAccesses;
      }
      else {
        print("Failed to load node accesses. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in getting all node accesses: $e");
      return [];
    }
  }


  Future<int> addNodeAccess(int roleId,int userId, int nodeId) async{
    var pref = await SharedPreferences.getInstance();
    try{

      String? token = pref.getString("token");

      var url = Uri.parse(APIConstant.AddNodeURL);   /// take note

      var body = json.encode({
        "role_id": roleId,
        "user_id": userId,
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
      print('error in add node access');
      print(e.toString());
      return 3;
    }
  }

  Future<bool> updateNodeAccess(NodeAccess nodeAccess) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");

      if (token!.isNotEmpty) {
        var url = Uri.parse(APIConstant.UpdateConfigURL+"/${nodeAccess.id}");  // take note
        print(url);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var body = json.encode({
          "role_id": nodeAccess.roleId,
          "user_id": nodeAccess.userId,
          "node_id": nodeAccess.nodeId

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


  // delete node access
  Future<bool> deleteNodeAccess(int nodeAccessId) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.DeleteNodeURL + "/${nodeAccessId.toString()}");  /// url
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
      print("error to delete node access ${e.toString()}");
      return false;
    }
  }

}