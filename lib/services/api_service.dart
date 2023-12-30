import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/contact_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.byteplex.info/api/test/contact/';

  Future<Map<String, dynamic>> postContact(ContactModel contact) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(contact.toJson()),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Sent successfully'};
      } else {
        return {'success': false, 'message': response.reasonPhrase};
      }
    } catch (error) {
      return {'success': false, 'message': 'Error during request'};
    }
  }
}
