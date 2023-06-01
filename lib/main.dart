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
  City cityPereira = City(name: "Pereira");
  City cityBarranquilla = City(name: "Barranquilla");
  City cityMedellin = City(name: "Medellín");
  City cityCali = City(name: "Cali");

  // Ejecutar el algoritmo de Dijkstra considerando conexiones terrestres y aéreas

  List<Widget> markers = [];
  int aux = 0;
  @override
  Widget build(BuildContext context) {
    cityArmenia.landConnections = [
      Connection(destination: cityValledupar, distance: 314),
      Connection(destination: cityBogota, distance: 278),
      Connection(destination: cityBucaramanga, distance: 188),
    ];

    cityValledupar.landConnections = [
      Connection(destination: cityArmenia, distance: 314),
      Connection(destination: cityBogota, distance: 537),
    ];

    cityBogota.landConnections = [
      Connection(destination: cityArmenia, distance: 278),
      Connection(destination: cityValledupar, distance: 537),
      Connection(destination: cityBarranquilla, distance: 893),
      Connection(destination: cityMedellin, distance: 257),
      Connection(destination: cityCali, distance: 395),
      Connection(destination: cityPereira, distance: 234)
    ];

    cityBucaramanga.landConnections = [
      Connection(destination: cityArmenia, distance: 188),
      Connection(destination: cityMedellin, distance: 246),
      Connection(destination: cityCali, distance: 456),
    ];

    cityPereira.landConnections = [
      Connection(destination: cityValledupar, distance: 207),
      Connection(destination: cityBarranquilla, distance: 68),
    ];

    cityBarranquilla.landConnections = [
      Connection(destination: cityBogota, distance: 893),
      Connection(destination: cityValledupar, distance: 118),
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
    // Agregar conexiones aéreas adicionales entre ciudades
    cityArmenia.airConnections = [
      Connection(destination: cityValledupar, distance: 350),
      Connection(destination: cityMedellin, distance: 300),
    ];

    cityValledupar.airConnections = [
      Connection(destination: cityArmenia, distance: 350),
      Connection(destination: cityBogota, distance: 400),
    ];

    cityBogota.airConnections = [
      Connection(destination: cityValledupar, distance: 400),
      Connection(destination: cityCali, distance: 350),
    ];

    cityBucaramanga.airConnections = [
      Connection(destination: cityMedellin, distance: 250),
      Connection(destination: cityCali, distance: 400),
    ];

    cityPereira.airConnections = [
      Connection(destination: cityBarranquilla, distance: 450),
      Connection(destination: cityMedellin, distance: 150),
    ];

    cityBarranquilla.airConnections = [
      Connection(destination: cityPereira, distance: 450),
      Connection(destination: cityBogota, distance: 500),
    ];

    cityMedellin.airConnections = [
      Connection(destination: cityArmenia, distance: 300),
      Connection(destination: cityBucaramanga, distance: 250),
      Connection(destination: cityPereira, distance: 40),
    ];

    cityCali.airConnections = [
      Connection(destination: cityBogota, distance: 350),
      Connection(destination: cityBucaramanga, distance: 400),
    ];

    // Crear las conexiones marítimas entre ciudades

    // Crear las conexiones por tren entre ciudades
    cityBogota.trainConnections = [
      Connection(destination: cityMedellin, distance: 400),
      Connection(destination: cityCali, distance: 600),
    ];

    cityMedellin.trainConnections = [
      Connection(destination: cityBogota, distance: 400),
      Connection(destination: cityCali, distance: 350),
    ];

    cityCali.trainConnections = [
      Connection(destination: cityBogota, distance: 600),
      Connection(destination: cityMedellin, distance: 350),
    ];

// Agregado a la lista de ciudades
    List<City> cities = [
      cityArmenia,
      cityValledupar,
      cityBogota,
      cityPereira,
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
              child: const Icon(Icons.car_crash),
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
              child: const Text('Terrestre'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                cargarVentanaAereo();
              },
              child: const Text('Aerea'),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Advertencia'),
                      content: const Text(
                          'CUIDADO: Algunas ciudades no poseen conexión marítima.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            cargarVentanaMaritimo();
                          },
                          child: const Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Marítima'),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Advertencia'),
                      content: const Text(
                          'CUIDADO: Algunas ciudades no poseen conexión ferrea.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            cargarVentanaFerreo();
                          },
                          child: const Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Ferrea'),
            ),
          ],
        );
      },
    );
  }

  void cargarVentanaTerrestre() {
    List<City> shortestPath = dijkstra(
        selectedCityOrigin!, selectedCityDestination!,
        includeAirConnections: false,
        includeSeaConnections: false,
        includeTrainConnections: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ruta más corta"),
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
                setState(() {});
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void cargarVentanaFerreo() {
    List<City> shortestPath = dijkstra(
        selectedCityOrigin!, selectedCityDestination!,
        includeAirConnections: false,
        includeSeaConnections: false,
        includeTrainConnections: true);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ruta más corta"),
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
                setState(() {});
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void cargarVentanaMaritimo() {
    List<City> shortestPath = dijkstra(
        selectedCityOrigin!, selectedCityDestination!,
        includeAirConnections: false,
        includeSeaConnections: true,
        includeTrainConnections: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ruta más corta"),
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
                setState(() {});
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void cargarVentanaAereo() {
    List<City> shortestPath = dijkstra(
        selectedCityOrigin!, selectedCityDestination!,
        includeAirConnections: true,
        includeSeaConnections: false,
        includeTrainConnections: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ruta más corta"),
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
                setState(() {});
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
