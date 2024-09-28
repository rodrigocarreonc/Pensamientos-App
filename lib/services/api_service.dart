import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://letters.rodrigocarreon.com/api/";

  Future<List<dynamic>> fetchLetters() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  Future<void> addLetter(String titulo, String pensamiento, String? autor) async {
    // Cuerpo del POST, omitimos 'autor' si es null o vacío
    Map<String, dynamic> body = {
      "titulo": titulo,
      "texto": pensamiento,
    };

    if (autor != null && autor.isNotEmpty) {
      body["autor"] = autor;
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
  }

  Future<void> updateLetter(int id, String titulo, String pensamiento, String autor) async {
    final response = await http.put(
      Uri.parse("$baseUrl$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "titulo": titulo,
        "texto": pensamiento,
        "autor": autor,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el registro');
    }
  }

  Future<void> deleteLetter(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl$id"));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el registro');
    }
  }
}
