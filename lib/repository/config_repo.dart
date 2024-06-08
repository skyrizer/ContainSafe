import 'dart:convert';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/config/config.dart';

class ConfigRepository {

  Future<List<Config>> getAllConfigs() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      print(token);
      var url = Uri.parse(APIConstant.GetConfigsURL);  ///  tak tukar url lagii
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> jsonData = responseData['configs']; // Accessing the 'nodes' key

        List<Config> configs = jsonData.map((data) => Config.fromJson(data)).toList();

        return configs;
      } else {
        print("Failed to load nodes. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in getting all nodes: $e");
      return [];
    }
  }

  Future<int> addConfig(String name, String unit) async{
    var pref = await SharedPreferences.getInstance();
    try{

      String? token = pref.getString("token");

      var url = Uri.parse(APIConstant.AddConfigURL);

      var body = json.encode({
        "name": name,
        "unit": unit
      });

      print(body.toString());
      var response = await http.post(url,
          headers: {"Content-Type": "application/json","Authorization": "Bearer ${token}"},
          body: body
      );

      if (response.statusCode == 200){
        return 0;
      }
      else {
        return 3;
      }


    } catch (e) {
      print('error in add config');
      print(e.toString());
      return 3;
    }
  }


  Future<bool> updateConfig(Config config) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");

      if (token!.isNotEmpty) {
        var url = Uri.parse(APIConstant.UpdateConfigURL+"/${config.id}");  // take note
        print(url);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var body = json.encode({
          "name": config.name,
          "unit": config.unit,

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