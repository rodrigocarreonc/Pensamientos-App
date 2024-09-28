import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EscribirScreen extends StatefulWidget {
  @override
  _EscribirScreenState createState() => _EscribirScreenState();
}

class _EscribirScreenState extends State<EscribirScreen> {
  final _tituloController = TextEditingController();
  final _pensamientoController = TextEditingController();
  final _autorController = TextEditingController(); // Campo opcional
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Escribir Pensamiento")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: "Titulo"),
            ),
            TextField(
              controller: _pensamientoController,
              decoration: InputDecoration(labelText: "Pensamiento"),
            ),
            TextField(
              controller: _autorController, // Campo opcional
              decoration: InputDecoration(
                labelText: "Autor (Opcional)",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Validación básica para los campos obligatorios
                if (_tituloController.text.isNotEmpty &&
                    _pensamientoController.text.isNotEmpty) {
                  try {
                    await apiService.addLetter(
                      _tituloController.text,
                      _pensamientoController.text,
                      _autorController.text.isEmpty ? null : _autorController.text, // Enviamos null si está vacío
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al enviar el pensamiento: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, llena todos los campos obligatorios')),
                  );
                }
              },
              child: Text("Enviar"),
            ),
          ],
        ),
      ),
    );
  }
}

