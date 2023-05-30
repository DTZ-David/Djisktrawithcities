import 'package:djkistra_01/ciudad.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'Algoritmo de Djikstra'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  City? selectedCityOrigin;
  City? selectedCityDestination;
  // Creación de ciudades
  City cityArmenia = City(name: "Armenia", connections: []);
  City cityValledupar = City(name: "Valledupar", connections: []);
  City cityBogota = City(name: "Bogotá", connections: []);
  City cityBucaramanga = City(name: "Bucaramanga", connections: []);
  City cityCartagena = City(name: "Cartagena", connections: []);
  City cityPereira = City(name: "Pereira", connections: []);
  City cityBarranquilla = City(name: "Barranquilla", connections: []);
  City cityMedellin = City(name: "Medellín", connections: []);
  City cityCali = City(name: "Cali", connections: []);

  List<Widget> markers = [];
  int aux = 0;
  @override
  Widget build(BuildContext context) {
// Creación de conexiones con pesos
    cityArmenia.connections = [
      Connection(destination: cityValledupar, distance: 100),
      Connection(destination: cityBogota, distance: 200),
    ];
    cityValledupar.connections = [
      Connection(destination: cityArmenia, distance: 100),
      Connection(destination: cityBogota, distance: 300),
    ];
    cityBogota.connections = [
      Connection(destination: cityArmenia, distance: 200),
      Connection(destination: cityValledupar, distance: 300),
    ];
    cityBucaramanga.connections = [
      Connection(destination: cityMedellin, distance: 400),
      Connection(destination: cityBarranquilla, distance: 500),
    ];
    cityCartagena.connections = [
      Connection(destination: cityBarranquilla, distance: 200),
    ];
    cityPereira.connections = [
      Connection(destination: cityArmenia, distance: 150),
      Connection(destination: cityCali, distance: 250),
    ];
    cityBarranquilla.connections = [
      Connection(destination: cityCartagena, distance: 200),
      Connection(destination: cityBucaramanga, distance: 500),
    ];
    cityMedellin.connections = [
      Connection(destination: cityBucaramanga, distance: 400),
      Connection(destination: cityCali, distance: 600),
    ];
    cityCali.connections = [
      Connection(destination: cityMedellin, distance: 600),
      Connection(destination: cityPereira, distance: 250),
    ];

// Agregado a la lista de ciudades
    List<City> cities = [
      cityArmenia,
      cityValledupar,
      cityBogota,
      cityBucaramanga,
      cityCartagena,
      cityPereira,
      cityBarranquilla,
      cityMedellin,
      cityCali,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Ciudad de origen: "),
                DropdownButton<City>(
                  value: selectedCityOrigin,
                  onChanged: (City? city) {
                    setState(() {
                      selectedCityOrigin = city;
                      _mostrarIcons(selectedCityOrigin!);

                      if (aux > 2) {
                        markers.clear();
                      }
                    });
                  },
                  items: cities.map<DropdownMenuItem<City>>((City city) {
                    return DropdownMenuItem<City>(
                      value: city,
                      child: Text(city.name),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Ciudad de destino: "),
                DropdownButton<City>(
                  value: selectedCityDestination,
                  onChanged: (City? city) {
                    setState(() {
                      selectedCityDestination = city;
                      _mostrarIcons(selectedCityDestination!);
                      if (aux > 2) {
                        markers.clear();
                      }
                    });
                  },
                  items: cities.map<DropdownMenuItem<City>>((City city) {
                    return DropdownMenuItem<City>(
                      value: city,
                      child: Text(city.name),
                    );
                  }).toList(),
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                SizedBox(
                  height: 500,
                  width: 500,
                  child: Image.asset("assets/images/mapa1.png"),
                ),
                ...markers, // Mostramos los marcadores en el mapa
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedCityDestination == null ||
                    selectedCityOrigin == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.pink,
                      content: Text(
                        'Por favor ingrese ciudad de origen y/o destino',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  cargarVentana();
                }
              },
              child: Icon(Icons.car_crash),
            )
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void cargarVentana() {
    List<City> shortestPath =
        dijkstra(selectedCityOrigin!, selectedCityDestination!);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ruta más corta"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Para ajustar la altura al contenido
              children: shortestPath.map((City city) {
                return Text(city.name);
              }).toList(),
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(
              24.0, 20.0, 24.0, 0.0), // Ajustar los valores según sea necesario
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarIcons(City selectedCity) {
    setState(() {
      if (selectedCity.name == 'Cartagena') {
        aux = aux + 1;
        markers.add(
          const Positioned(
            top: 60,
            left: 160,
            child: Icon(
              Icons.location_on,
              color: Colors.amberAccent,
              size: 20,
            ),
          ),
        );
      }
      if (selectedCity.name == 'Bucaramanga') {
        aux = aux + 1;
        markers.add(
          const Positioned(
            top: 200,
            left: 250,
            child: Icon(
              Icons.location_on,
              color: Colors.green,
              size: 20,
            ),
          ),
        );
      }
      if (selectedCity.name == 'Pereira') {
        aux = aux + 1;
        markers.add(
          const Positioned(
            top: 230,
            left: 150,
            child: Icon(
              Icons.location_on,
              color: Colors.green,
              size: 20,
            ),
          ),
        );
      }
      if (selectedCity.name == 'Bogotá') {
        aux = aux + 1;
        markers.add(
          const Positioned(
            top: 220,
            left: 190,
            child: Icon(
              Icons.location_on,
              color: Colors.green,
              size: 20,
            ),
          ),
        );
      }
      if (selectedCity.name == 'Barranquilla') {
        aux = aux + 1;
        markers.add(
          const Positioned(
            top: 40,
            left: 180,
            child: Icon(
              Icons.location_on,
              color: Colors.green,
              size: 20,
            ),
          ),
        );
      }
      if (selectedCity.name == 'Valledupar') {
        aux = aux + 1;
        markers.add(
          const Positioned(
            top: 60,
            left: 220,
            child: Icon(
              Icons.location_on,
              color: Colors.green,
              size: 20,
            ),
          ),
        );
      }
      if (selectedCity.name == 'Medellín') {
        aux = aux + 1;
        markers.add(
          const Positioned(
            top: 180,
            left: 170,
            child: Icon(
              Icons.location_on,
              color: Colors.green,
              size: 20,
            ),
          ),
        );
      }
      if (selectedCity.name == 'Armenia') {
        aux = aux + 1;
        markers.add(
          const Positioned(
            top: 210,
            left: 150,
            child: Icon(
              Icons.location_on,
              color: Colors.green,
              size: 20,
            ),
          ),
        );
      }
      if (selectedCity.name == 'Cali') {
        aux = aux + 1;
        markers.add(
          const Positioned(
            top: 250,
            left: 130,
            child: Icon(
              Icons.location_on,
              color: Colors.orange,
              size: 20,
            ),
          ),
        );
      }
    });
  }
}
