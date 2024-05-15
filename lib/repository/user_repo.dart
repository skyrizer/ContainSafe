import 'dart:convert';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user/user.dart';

class UserRepository {

  Future<List<User>> getAllUsers() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      print(token);
      var url = Uri.parse(APIConstant.GetUsersURL);    ////
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);

      if (response.statusCode == 200) {

        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> jsonData = responseData['users'];

        List<User> users = jsonData.map((data) => User.fromJson(data)).toList();

        return users;
      } else {
        print("Failed to load users. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error in getting all users: $e");
      return [];
    }
  }

  // Future<int> addNode(String hostname, String ipAddress) async{
  //   var pref = await SharedPreferences.getInstance();
  //   try{
  //
  //     String? token = pref.getString("token");
  //
  //     var url = Uri.parse(APIConstant.AddNodeURL);
  //
  //     var body = json.encode({
  //       "hostname": hostname,
  //       "ip_address": ipAddress
  //     });
  //
  //     print(body.toString());
  //     var response = await http.post(url,
  //         headers: {"Content-Type": "application/json","Authorization": "Bearer ${token}"},
  //         body: body
  //     );
  //
  //     if (response.statusCode == 200){
  //       // String data =  response.body;
  //       // pref.setString("token", data);
  //       return 0;
  //     }
  //     else {
  //       return 3;
  //     }
  //
  //
  //   } catch (e) {
  //     print('error in add node');
  //     print(e.toString());
  //     return 3;
  //   }
  // }
  //
  // // delete node
  // Future<bool> deleteNode(int nodeId) async{
  //   try{
  //     var pref = await SharedPreferences.getInstance();
  //     String? token = pref.getString("token");
  //     var url = Uri.parse(APIConstant.DeleteNodeURL + "/${nodeId.toString()}");
  //     var header = {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer ${token}",
  //     };
  //     var response = await http.delete(url, headers: header);
  //     if (response.statusCode == 200){
  //
  //       return true;
  //     }else{
  //       return false;
  //     }
  //
  //   } catch (e){
  //     print("error to delete post ${e.toString()}");
  //     return false;
  //   }
  // }

}