import 'package:djkistra_01/maritimo.dart';
import 'package:djkistra_01/tren.dart';
import 'package:djkistra_01/vuelos.dart';
import 'package:flutter/material.dart';

import 'ciudad.dart';

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
  Maritimo? selectedSeaOrigin;
  Maritimo? selectedSeaDestination;
  Tren? selectedTrainOrigin;
  Tren? selectedTrainDestination;
  Vuelo? selectedVuelorigin;
  Vuelo? selectedVueloDestination;
  // Creación de ciudades
  City cityArmenia = City(name: "Armenia");
  City cityValledupar = City(name: "Valledupar");
  City cityBogota = City(name: "Bogotá");
  City cityBucaramanga = City(name: "Bucaramanga");
  City cityPereira = City(name: "Pereira");
  City cityBarranquilla = City(name: "Barranquilla");
  City cityMedellin = City(name: "Medellín");
  City cityCali = City(name: "Cali");

  Vuelo cityArmeniaV = Vuelo(nombre: "Armenia");
  Vuelo cityValleduparV = Vuelo(nombre: "Valledupar");
  Vuelo cityBogotaV = Vuelo(nombre: "Bogotá");
  Vuelo cityBucaramangaV = Vuelo(nombre: "Bucaramanga");
  Vuelo cityPereiraV = Vuelo(nombre: "Pereira");
  Vuelo cityBarranquillaV = Vuelo(nombre: "Barranquilla");
  Vuelo cityMedellinV = Vuelo(nombre: "Medellín");
  Vuelo cityCaliV = Vuelo(nombre: "Cali");
  // Ejecutar el algoritmo de Dijkstra considerando conexiones terrestres y aéreas

  Maritimo cityArmeniaM = Maritimo(nombre: "Armenia");
  Maritimo cityValleduparM = Maritimo(nombre: "Valledupar");
  Maritimo cityBogotaM = Maritimo(nombre: "Bogotá");
  Maritimo cityBucaramangaM = Maritimo(nombre: "Bucaramanga");
  Maritimo cityPereiraM = Maritimo(nombre: "Pereira");
  Maritimo cityBarranquillaM = Maritimo(nombre: "Barranquilla");
  Maritimo cityMedellinM = Maritimo(nombre: "Medellín");
  Maritimo cityCaliM = Maritimo(nombre: "Cali");

  Tren cityArmeniaT = Tren(nombre: "Armenia");
  Tren cityValleduparT = Tren(nombre: "Valledupar");
  Tren cityBogotaT = Tren(nombre: "Bogotá");
  Tren cityBucaramangaT = Tren(nombre: "Bucaramanga");
  Tren cityPereiraT = Tren(nombre: "Pereira");
  Tren cityBarranquillaT = Tren(nombre: "Barranquilla");
  Tren cityMedellinT = Tren(nombre: "Medellín");
  Tren cityCaliT = Tren(nombre: "Cali");

  List<Widget> markers = [];
  int aux = 0;
  @override
  Widget build(BuildContext context) {
    cityArmenia.landConnections = [
      Connection(destination: cityValledupar, distance: 414),
      Connection(destination: cityBogota, distance: 378),
      Connection(destination: cityBucaramanga, distance: 288),
    ];

    cityValledupar.landConnections = [
      Connection(destination: cityArmenia, distance: 414),
      Connection(destination: cityBogota, distance: 637),
    ];

    cityBogota.landConnections = [
      Connection(destination: cityArmenia, distance: 378),
      Connection(destination: cityValledupar, distance: 637),
      Connection(destination: cityBarranquilla, distance: 993),
      Connection(destination: cityMedellin, distance: 357),
      Connection(destination: cityCali, distance: 495),
      Connection(destination: cityPereira, distance: 334)
    ];

    cityBucaramanga.landConnections = [
      Connection(destination: cityArmenia, distance: 288),
      Connection(destination: cityMedellin, distance: 346),
      Connection(destination: cityCali, distance: 556),
    ];

    cityPereira.landConnections = [
      Connection(destination: cityValledupar, distance: 307),
      Connection(destination: cityBarranquilla, distance: 168),
    ];

    cityBarranquilla.landConnections = [
      Connection(destination: cityBogota, distance: 993),
      Connection(destination: cityValledupar, distance: 218),
    ];

    cityMedellin.landConnections = [
      Connection(destination: cityBogota, distance: 357),
      Connection(destination: cityBucaramanga, distance: 346),
    ];

    cityCali.landConnections = [
      Connection(destination: cityBogota, distance: 495),
      Connection(destination: cityBucaramanga, distance: 556),
    ];

    // Crear las conexiones aéreas entre ciudades
    // Agregar conexiones aéreas adicionales entre ciudades
    cityArmeniaV.airConnections = [
      ConnectionV(destination: cityValleduparV, distance: 250),
      ConnectionV(destination: cityMedellinV, distance: 200),
    ];

    cityValleduparV.airConnections = [
      ConnectionV(destination: cityArmeniaV, distance: 250),
      ConnectionV(destination: cityBogotaV, distance: 200),
    ];

    cityBogotaV.airConnections = [
      ConnectionV(destination: cityValleduparV, distance: 300),
      ConnectionV(destination: cityCaliV, distance: 250),
    ];

    cityBucaramangaV.airConnections = [
      ConnectionV(destination: cityMedellinV, distance: 150),
      ConnectionV(destination: cityCaliV, distance: 300),
    ];

    cityPereiraV.airConnections = [
      ConnectionV(destination: cityBarranquillaV, distance: 350),
      ConnectionV(destination: cityMedellinV, distance: 50),
    ];

    cityBarranquillaV.airConnections = [
      ConnectionV(destination: cityPereiraV, distance: 350),
      ConnectionV(destination: cityBogotaV, distance: 400),
    ];

    cityMedellinV.airConnections = [
      ConnectionV(destination: cityArmeniaV, distance: 200),
      ConnectionV(destination: cityBucaramangaV, distance: 150),
      ConnectionV(destination: cityPereiraV, distance: 20),
    ];

    cityCaliV.airConnections = [
      ConnectionV(destination: cityBogotaV, distance: 250),
      ConnectionV(destination: cityBucaramangaV, distance: 300),
    ];

    cityBogotaT.trainConnections = [
      ConnectionT(destination: cityMedellinT, distance: 409),
    ];

    cityMedellinT.trainConnections = [
      ConnectionT(destination: cityBogotaT, distance: 409),
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
    List<Vuelo> vuelos = [
      cityArmeniaV,
      cityValleduparV,
      cityBogotaV,
      cityPereiraV,
      cityBucaramangaV,
      cityBarranquillaV,
      cityMedellinV,
      cityCaliV,
    ];
    List<Maritimo> mares = [
      cityArmeniaM,
      cityValleduparM,
      cityBogotaM,
      cityPereiraM,
      cityBucaramangaM,
      cityBarranquillaM,
      cityMedellinM,
      cityCaliM,
    ];
    List<Tren> tren = [
      cityArmeniaT,
      cityValleduparT,
      cityBogotaT,
      cityPereiraT,
      cityBucaramangaT,
      cityBarranquillaT,
      cityMedellinT,
      cityCaliT,
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
                      var aux1 = selectedCityOrigin!.name;
                      for (int i = 0; i < vuelos.length; i++) {
                        if (vuelos[i].nombre == aux1) {
                          selectedVuelorigin = vuelos[i];
                          selectedSeaOrigin = mares[i];
                          selectedTrainOrigin = tren[i];
                        }
                      }
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
                      var aux1 = selectedCityDestination!.name;
                      for (int i = 0; i < vuelos.length; i++) {
                        if (vuelos[i].nombre == aux1) {
                          selectedVueloDestination = vuelos[i];
                          selectedSeaDestination = mares[i];
                          selectedTrainDestination = tren[i];
                        }
                      }
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
                Navigator.of(context).pop();
                cargarVentanaMaritimo();
              },
              child: const Text('Maritimo'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                cargarVentanaFerreo();
              },
              child: const Text('Ferreo'),
            ),
          ],
        );
      },
    );
  }

  void cargarVentanaFerreo() {
    ShortestPathTrainaResult result =
        dijkstraTrain(selectedTrainOrigin!, selectedTrainDestination!);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ruta más corta"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...result.shortestPath.map((Tren tren) {
                  return Text(tren.nombre);
                }).toList(),
                SizedBox(
                    height:
                        20), // Espacio entre las ciudades y la suma de distancias
                Text(
                  "Suma de distancias: ${result.totalDistance}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
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

  void cargarVentanaTerrestre() {
    ShortestPathCityResult result =
        dijkstraT(selectedCityOrigin!, selectedCityDestination!);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ruta más corta"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...result.shortestPath.map((City city) {
                  return Text(city.name);
                }).toList(),
                SizedBox(
                    height:
                        20), // Espacio entre las ciudades y la suma de distancias
                Text(
                  "Suma de distancias: ${result.totalDistance}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
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
    ShortestPathFlyResult result =
        dijkstraV(selectedVuelorigin!, selectedVueloDestination!);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ruta más corta"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...result.shortestPath.map((Vuelo vuelo) {
                  return Text(vuelo.nombre);
                }).toList(),
                const SizedBox(
                    height:
                        20), // Espacio entre las ciudades y la suma de distancias
                Text(
                  "Suma de distancias: ${result.totalDistance}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
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
    ShortestPathSeaResult result =
        dijkstraM(selectedSeaOrigin!, selectedSeaDestination!);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ruta más corta"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...result.shortestPath.map((Maritimo mar) {
                  return Text(mar.nombre);
                }).toList(),
                const SizedBox(
                    height:
                        20), // Espacio entre las ciudades y la suma de distancias
                Text(
                  "Suma de distancias: ${result.totalDistance}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
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
