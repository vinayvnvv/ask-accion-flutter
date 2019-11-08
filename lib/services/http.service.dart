import '../env.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String _baseUrl = environment['baseUrl'];
  getEmp(String email) {
    return http.get(
        _baseUrl + 'get-emp/' + email, 
        headers: {"Content-Type": "application/json"}
      );
  }
}