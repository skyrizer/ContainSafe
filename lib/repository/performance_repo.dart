import 'dart:convert';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/performance/performance_model.dart';

class PerformanceRepository {

  Future<List<Performance>> getAllPerformances() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      print(token);
      var url = Uri.parse(APIConstant.PerformanceURL);
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        List<Performance> performances = [];

        jsonData.forEach((containerName, data) {
          performances.add(Performance(
            containerName: containerName,
            diskUsage: List<Map<String, dynamic>>.from(data['diskUsage'] ?? []),
            cpuUsage: List<Map<String, dynamic>>.from(data['cpuUsage'] ?? []),
            memoryUsage: List<Map<String, dynamic>>.from(data['memoryUsage'] ?? []),
            networkUsage: List<Map<String, dynamic>>.from(data['networkUsage'] ?? []),
            error: "",
          ));
        });

        return performances;
      } else {
        print("Failed to load performances. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in getting all container performances: $e");
      return [];
    }
  }

}