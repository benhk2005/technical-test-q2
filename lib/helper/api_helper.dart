import 'dart:convert';

import 'package:moovup_flutter/model/person.dart';
import 'package:http/http.dart' as http;

abstract class APIHelper {
  static const String url =
      "https://api.json-generator.com/templates/-xdNcNKYtTFG/data";
  static const String apiToken = "b2atclr0nk1po45amg305meheqf4xrjt9a1bo410";

  static Future<List<Person>> getPeople() async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $apiToken",
      },
    );
    if (response.statusCode == 200) {
      List<Person> output = List.empty(growable: true);
      final jsonDecoded = jsonDecode(response.body);
      final jsonArray = jsonDecoded as List<dynamic>?;
      for (int i = 0; i < (jsonArray?.length ?? 0); i++) {
        final jsonObject = jsonArray?[i] as Map<String, dynamic>;
        final personCandidate = Person.fromAPI(jsonObject);
        if (personCandidate != null) {
          output.add(personCandidate);
        }
      }
      return output;
    } else {
      throw Error();
    }
  }
}
