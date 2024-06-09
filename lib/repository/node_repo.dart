import 'dart:convert';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/node/node.dart';

class NodeRepository {

  Future<List<Node>> getAllNodes() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      print(token);
      var url = Uri.parse(APIConstant.GetUserNodeURL);
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> jsonData = responseData['nodes']; // Accessing the 'nodes' key

        List<Node> nodes = jsonData.map((data) => Node.fromJson(data)).toList();

        return nodes;
      } else {
        print("Failed to load nodes. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in getting all nodes: $e");
      return [];
    }
  }

  Future<int> addNode(String hostname, String ipAddress) async {
    var pref = await SharedPreferences.getInstance();
    try {
      String? token = pref.getString("token");
      int? roleId = pref.getInt("roleId");
      int? userId = pref.getInt("userId");

      var url = Uri.parse(APIConstant.AddNodeURL);
      late String body; // Declare body variable

      if (roleId == 1) {
        body = json.encode({
          "hostname": hostname,
          "ip_address": ipAddress,
          "role_id": roleId,
          "user_id": userId
        });
      } else {
        body = json.encode({
          "hostname": hostname,
          "ip_address": ipAddress,
        });
      }

      print(body.toString());
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}"
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // String data =  response.body;
        // pref.setString("token", data);
        return 0;
      } else {
        return 3;
      }
    } catch (e) {
      print('error in add node');
      print(e.toString());
      return 3;
    }
  }


  // delete node
  Future<bool> deleteNode(int nodeId) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.DeleteNodeURL + "/${nodeId.toString()}");
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
      print("error to delete post ${e.toString()}");
      return false;
    }
  }

}