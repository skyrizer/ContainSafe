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
        List<
            dynamic> jsonData = responseData['configs']; // Accessing the 'nodes' key

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

}