import 'package:http/http.dart' as http;

class UserService {
  getDetails(int id) async {
    final url = 'http://10.0.2.2:8080/api/users/$id';
    return await http.get(Uri.parse(url), headers: setHeaders());
  }

  setHeaders() => {'Content-type': 'application/json', 'Accept': 'application/json'};
}
