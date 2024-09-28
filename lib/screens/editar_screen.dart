import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditarScreen extends StatefulWidget {
  @override
  _EditarScreenState createState() => _EditarScreenState();
}

class _EditarScreenState extends State<EditarScreen> {
  final _tituloController = TextEditingController();
  final _pensamientoController = TextEditingController();
  final _autorController = TextEditingController();
  ApiService apiService = ApiService();
  Map<String, dynamic>? letter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    letter = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (letter != null) {
      _tituloController.text = letter!['titulo'];
      _pensamientoController.text = letter!['texto'];
      _autorController.text = letter!['autor'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cambiar de Opinion")),
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
              controller: _autorController,
              decoration: InputDecoration(labelText: "Autor"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await apiService.updateLetter(
                  letter!['id'],
                  _tituloController.text,
                  _pensamientoController.text,
                  _autorController.text,
                );
                Navigator.pop(context);
              },
              child: Text("Actualizar"),
            ),
            ElevatedButton(
              onPressed: () async {
                await apiService.deleteLetter(letter!['id']);
                Navigator.pop(context);
              },
              child: Text("Eliminar"),
            ),
          ],
        ),
      ),
    );
  }
}
