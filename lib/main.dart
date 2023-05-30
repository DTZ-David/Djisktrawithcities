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
  City cityArmenia = City(name: "Armenia");
  City cityValledupar = City(name: "Valledupar");
  City cityBogota = City(name: "Bogotá");
  City cityBucaramanga = City(name: "Bucaramanga");
  City citySantaMarta = City(name: "Santa Marta");

  City cityBarranquilla = City(name: "Barranquilla");
  City cityMedellin = City(name: "Medellín");
  City cityCali = City(name: "Cali");

  // Ejecutar el algoritmo de Dijkstra considerando conexiones terrestres y aéreas

  List<Widget> markers = [];
  int aux = 0;
  @override
  Widget build(BuildContext context) {
// Creación de conexiones con pesos
    // Crear las conexiones terrestres entre ciudades
    cityArmenia.landConnections = [
      Connection(destination: cityValledupar, distance: 314),
      Connection(destination: cityBogota, distance: 278),
      Connection(destination: cityBucaramanga, distance: 188),
    ];

    cityValledupar.landConnections = [
      Connection(destination: cityArmenia, distance: 314),
      Connection(destination: cityBogota, distance: 537),
      Connection(destination: citySantaMarta, distance: 207),
    ];

    cityBogota.landConnections = [
      Connection(destination: cityArmenia, distance: 278),
      Connection(destination: cityValledupar, distance: 537),
      Connection(destination: cityBarranquilla, distance: 893),
      Connection(destination: cityMedellin, distance: 257),
      Connection(destination: cityCali, distance: 395),
    ];

    cityBucaramanga.landConnections = [
      Connection(destination: cityArmenia, distance: 188),
      Connection(destination: cityMedellin, distance: 246),
      Connection(destination: cityCali, distance: 456),
    ];

    citySantaMarta.landConnections = [
      Connection(destination: cityValledupar, distance: 207),
      Connection(destination: cityBarranquilla, distance: 68),
    ];

    cityBarranquilla.landConnections = [
      Connection(destination: cityBogota, distance: 893),
      Connection(destination: citySantaMarta, distance: 68),
    ];

    cityMedellin.landConnections = [
      Connection(destination: cityBogota, distance: 257),
      Connection(destination: cityBucaramanga, distance: 246),
    ];

    cityCali.landConnections = [
      Connection(destination: cityBogota, distance: 395),
      Connection(destination: cityBucaramanga, distance: 456),
    ];

    // Crear las conexiones aéreas entre ciudades
    cityBogota.airConnections = [
      Connection(destination: cityMedellin, distance: 200),
      Connection(destination: cityCali, distance: 300),
    ];

    cityMedellin.airConnections = [
      Connection(destination: cityBogota, distance: 200),
      Connection(destination: cityCali, distance: 250),
    ];

    cityCali.airConnections = [
      Connection(destination: cityBogota, distance: 300),
      Connection(destination: cityMedellin, distance: 250),
    ];

// Agregado a la lista de ciudades
    List<City> cities = [
      cityArmenia,
      cityValledupar,
      cityBogota,
      citySantaMarta,
      cityBucaramanga,
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
                        aux = 0;
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
                        aux = 0;
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
                  cargarVentanaConfirmacion();
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

  void cargarVentanaConfirmacion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¿Desea ruta terrestre o aerea?"),

          contentPadding: const EdgeInsets.fromLTRB(
              24.0, 20.0, 24.0, 0.0), // Ajustar los valores según sea necesario
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                cargarVentanaTerrestre();
              },
              child: Text('Terrestre'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                cargarVentanaAereo();
              },
              child: Text('Aerea'),
            ),
          ],
        );
      },
    );
  }

  void cargarVentanaTerrestre() {
    List<City> shortestPath = dijkstra(
        selectedCityOrigin!, selectedCityDestination!,
        includeAirConnections: false);

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

  void cargarVentanaAereo() {
    List<City> shortestPath = dijkstra(
        selectedCityOrigin!, selectedCityDestination!,
        includeAirConnections: true);

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
