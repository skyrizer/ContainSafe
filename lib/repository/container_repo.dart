import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:containsafe/repository/APIConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/container/container.dart';

class ContainerRepository {

  Future<ContainerModel?> getContainer(String containerId) async {
    try {
      ContainerModel containerResponse;
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      if (token!.isNotEmpty) {
        var url = Uri.parse(APIConstant.GetOneContainerURL + "/$containerId");
        print(url);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var response = await http.get(url, headers: header);
        print(response.body);
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = jsonDecode(response.body);
          Map<String, dynamic> jsonData = responseData['container']; // Accessing the 'container' key

          containerResponse = ContainerModel.fromJson(jsonData);
          return containerResponse;
        } else {
          print(response.statusCode);
        }
      }
    } catch (error) {
      print('error in get user ');
      print(error.toString());
    }
    return null;
  }

  Future<bool> updateContainer(ContainerModel container) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");

      if (token!.isNotEmpty) {
        var url = Uri.parse(APIConstant.UpdateContainerURL+"/${container.id}");  // take note
        print(url);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var body = json.encode({
          "disk_limit": container.diskLimit,
          "cpu_limit": container.cpuLimit,
          "mem_limit": container.memLimit,
          "net_limit": container.netLimit,

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