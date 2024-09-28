import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';  // Necesario para formatear la fecha
import 'package:shimmer/shimmer.dart';  // Importa el paquete shimmer para la animación de carga

class PrincipalScreen extends StatefulWidget {
  @override
  _PrincipalScreenState createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  ApiService apiService = ApiService();
  List<dynamic> letters = [];
  bool isLoading = true; // Bandera para controlar el estado de carga

  @override
  void initState() {
    super.initState();
    loadLetters();
  }

  Future<void> loadLetters() async {
    try {
      List<dynamic> data = await apiService.fetchLetters();

      // Ordena las cartas por fecha de la más reciente a la más antigua
      data.sort((a, b) {
        DateTime fechaA = DateTime.parse(a['fecha']);
        DateTime fechaB = DateTime.parse(b['fecha']);
        return fechaB.compareTo(fechaA); // Fecha más reciente primero
      });

      setState(() {
        letters = data;
        isLoading = false; // Carga completada
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rodrigo's Mind")),
      body: isLoading
          ? buildSkeletonLoader() // Mostrar el esqueleto si está cargando
          : buildLetterList(),    // Mostrar las cartas una vez que los datos se cargan
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/escribir');
        },
      ),
    );
  }

  // Función para construir el widget con las cartas reales
  Widget buildLetterList() {
    return ListView.builder(
      itemCount: letters.length,
      itemBuilder: (context, index) {
        var letter = letters[index];

        // Formateo de la fecha para mostrarla de manera más legible
        DateTime parsedDate = DateTime.parse(letter['fecha']);
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(parsedDate);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(  // Cambia ListTile por InkWell para manejar onTap
              onTap: () {
                Navigator.pushNamed(context, '/editar', arguments: letter);
              },
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      letter['titulo'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      letter['texto'],
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "- ${letter['autor']}",
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Función para construir el esqueleto (skeleton loader) durante la carga
  Widget buildSkeletonLoader() {
    return ListView.builder(
      itemCount: 6, // Número de tarjetas de esqueleto que quieres mostrar
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 20,
                      color: Colors.grey[300], // Título simulado
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 14,
                      color: Colors.grey[300], // Texto simulado
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 80,
                          height: 14,
                          color: Colors.grey[300], // Autor simulado
                        ),
                        Container(
                          width: 60,
                          height: 14,
                          color: Colors.grey[300], // Fecha simulada
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
