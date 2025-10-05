import 'dart:convert';

import 'package:http/http.dart' as http;

class NoteService {
  addNote(int id, Map data) async {
    final url = 'http://10.0.2.2:8080/api/todos/user/$id';
    return await http.post(Uri.parse(url), body: jsonEncode(data), headers: setHeaders());
  }

  getNote(int id) async {
    final url = 'http://10.0.2.2:8080/api/todos/user/$id';
    return await http.get(Uri.parse(url), headers: setHeaders());
  }

  updateNote(int id, bool data) async {
    final url = 'http://10.0.2.2:8080/api/todos/$id/status';
    return await http.put(Uri.parse(url), body: jsonEncode(data), headers: setHeaders());
  }

  deleteNote(int id) async {
    final url = 'http://10.0.2.2:8080/api/todos/$id';
    return await http.delete(Uri.parse(url), headers: setHeaders());
  }

  setHeaders() => {'Content-type': 'application/json', 'Accept': 'application/json'};
}
