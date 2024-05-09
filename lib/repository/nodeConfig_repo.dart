import 'dart:convert';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/nodeConfig/nodeConfig.dart';

class NodeConfigRepository {

  Future<List<NodeConfig>> getAllNodeConfigs() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      print(token);
      var url = Uri.parse(APIConstant.GetNodeConfigsURL);
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        Map<String, dynamic> nodeConfigsData = responseData['nodeConfigs'];

        List<NodeConfig> nodeConfigs = [];
        nodeConfigsData.forEach((key, value) {
          List<dynamic> configsData = value;
          configsData.forEach((configData) {
            NodeConfig nodeConfig = NodeConfig.fromJson(configData);
            nodeConfigs.add(nodeConfig);
          });
        });

        return nodeConfigs;
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

  Future<int> addNodeConfig(int configId, int nodeId, int value) async{
    var pref = await SharedPreferences.getInstance();
    try{

      String? token = pref.getString("token");

      var url = Uri.parse(APIConstant.AddNodeConfigsURL);

      var body = json.encode({
        "config_id": configId,
        "node_id": nodeId,
        "value": value
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
      print('error in add node');
      print(e.toString());
      return 3;
    }
  }


}