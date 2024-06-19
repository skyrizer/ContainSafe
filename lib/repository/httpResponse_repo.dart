import 'dart:convert';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/httpResponse/httpResponse.dart';

class HttpResponseRepository {

  Future<List<HttpResponse>> getHttpResponses() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      print(token);
      var url = Uri.parse(APIConstant.GetHttpResponsesURL);
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> jsonData = responseData['httpResponse']; // Accessing the 'httpResponse' key

        List<HttpResponse> nodes = jsonData.map((data) => HttpResponse.fromJson(data)).toList();

        return nodes;
      } else {
        print("Failed to load http responses. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in getting all nodes: $e");
      return [];
    }
  }

  Future<List<HttpResponse>> searchByCode(int statusCode) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      print(token);
      var url = Uri.parse(APIConstant.SearchByCodeURL);
      var body = json.encode({
        "status_code": statusCode,

      });
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.post(url, headers: header, body: body);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> jsonData = responseData['httpResponse']; // Accessing the 'httpResponse' key

        List<HttpResponse> nodes = jsonData.map((data) => HttpResponse.fromJson(data)).toList();

        return nodes;
      } else {
        print("Failed to load http responses. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in getting all http responses: $e");
      return [];
    }
  }

  Future<List<HttpResponse>> searchByDate(String startDate, String endDate) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      print(token);
      var url = Uri.parse(APIConstant.SearchByDateURL);
      var body = json.encode({
        "start_date": startDate,
        "end_date": endDate

      });
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.post(url, headers: header, body: body);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> jsonData = responseData['httpResponse']; // Accessing the 'httpResponse' key

        List<HttpResponse> nodes = jsonData.map((data) => HttpResponse.fromJson(data)).toList();

        return nodes;
      } else {
        print("Failed to load http responses. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in getting all http responses: $e");
      return [];
    }
  }

}