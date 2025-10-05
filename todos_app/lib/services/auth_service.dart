import 'dart:convert';
import 'package:http/http.dart' as http;

class CallAPI {
  final String url = 'http://10.0.2.2:8080/api/auth/';

  // http://10.0.2.2:8000 - emulator

  postData(data, apiURL) async {
    var fullUrl = url + apiURL;

    return await http.post(Uri.parse(fullUrl), body: jsonEncode(data), headers: setHeaders());
  }

  setHeaders() => {'Content-type': 'application/json', 'Accept': 'application/json'};
}
