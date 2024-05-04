import 'dart:convert';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/performance/performance_model.dart';

class PerformanceRepository {

  Future<List<Performance>> getAllPerformances({int? nodeId}) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      print(token);
      var url = Uri.parse(APIConstant.PerformanceURL);
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };

      var body = json.encode({
        'nodeId': nodeId
      });

      var response = await http.post(
          url,
          headers: header,
          body: body
      );



      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        List<Performance> performances = [];

        if (jsonData.isEmpty) {
          // Handle empty list case
          print("Response body is empty.");
          // Return an empty list of performances
          return performances;
        }

        List<Map<String, dynamic>> _convertToUsageList(dynamic usageData) {
          if (usageData is Map<String, dynamic>) {
            // If usage data is a map, convert it to a list with a single entry
            return [usageData];
          } else if (usageData is List<Map<String, dynamic>>) {
            // If usage data is already a list, return it as is
            return usageData;
          } else {
            // Handle unexpected types gracefully
            return [];
          }
        }

        jsonData.keys.forEach((containerName) {
          Map<String, dynamic> data = jsonData[containerName];

          // Convert map to list if necessary
          List<Map<String, dynamic>> diskUsage = _convertToUsageList(data['diskUsage']);
          List<Map<String, dynamic>> cpuUsage = _convertToUsageList(data['cpuUsage']);
          List<Map<String, dynamic>> memoryUsage = _convertToUsageList(data['memoryUsage']);
          List<Map<String, dynamic>> networkUsage = _convertToUsageList(data['networkUsage']);

          performances.add(Performance(
            containerName: containerName,
            diskUsage: diskUsage,
            cpuUsage: cpuUsage,
            memoryUsage: memoryUsage,
            networkUsage: networkUsage,
            error: "",
          ));
        });

        return performances;
      } else if (response.statusCode == 404) {
        List<Performance> performances = [];
        return performances;
      } else{
        print("Failed to load performances. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in getting all container performances: $e");
      return [];
    }
  }


}