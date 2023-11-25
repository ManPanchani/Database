// import 'dart:convert';
//
// import 'package:demo1/homeScreens/model/model.dart';
// import 'package:http/http.dart' as http;
//
// class ApiHelper {
//   ApiHelper._();
//
//   static final ApiHelper apiHelper = ApiHelper._();
//
//   Future<List<User>?> fetchData() async {
//     String url = "https://jsonplaceholder.org/users";
//
//     http.Response res = await http.get(Uri.parse(url));
//
//     if (res.statusCode == 200) {
//       List decodeData = await jsonDecode(res.body);
//
//       List<User> allData =
//           decodeData.map((e) => User.fromMap(data: e)).toList();
//
//       print("====================");
//       print(allData);
//       print("====================");
//
//       return allData;
//     }
//     return null;
//   }
// }
