class City {
  final String name;
  late List<Connection> landConnections;
  late List<Connection> airConnections;
  late List<Connection> seaConnections;
  late List<Connection> trainConnections;

  City({
    required this.name,
    List<Connection>? landConnections,
    List<Connection>? airConnections,
    List<Connection>? seaConnections,
    List<Connection>? trainConnections,
  }) {
    this.landConnections = landConnections ?? [];
    this.airConnections = airConnections ?? [];
    this.seaConnections = seaConnections ?? [];
    this.trainConnections = trainConnections ?? [];
  }
}

class Connection {
  final City destination;
  final int distance;

  Connection({required this.destination, required this.distance});
}

List<City> dijkstra(City start, City end,
    {bool includeAirConnections = false,
    bool includeSeaConnections = false,
    bool includeTrainConnections = false}) {
  final Map<City, int> distances = {};
  final Map<City, City> previousCities = {};
  final Set<City> visitedCities = <City>{};

  distances[start] = 0;

  while (visitedCities.length < distances.length) {
    City currentCity = getCityWithShortestDistance(distances, visitedCities);

    if (currentCity == end) {
      break; // Llegamos a la ciudad de destino, terminamos el algoritmo
    }

    visitedCities.add(currentCity);

    List<Connection> connections = currentCity.landConnections;

    if (includeAirConnections) {
      connections.addAll(currentCity.airConnections);
    }

    if (includeSeaConnections) {
      connections.addAll(currentCity.seaConnections);
    }

    if (includeTrainConnections) {
      connections.addAll(currentCity.trainConnections);
    }

    for (Connection connection in connections) {
      int distance = distances[currentCity]! + connection.distance;

      if (!distances.containsKey(connection.destination) ||
          distance < distances[connection.destination]!) {
        distances[connection.destination] = distance;
        previousCities[connection.destination] = currentCity;
      }
    }
  }

  return buildShortestPath(end, previousCities);
}

City getCityWithShortestDistance(
    Map<City, int> distances, Set<City> visitedCities) {
  City? shortestCity;
  int shortestDistance = 99999;

  for (var entry in distances.entries) {
    if (entry.value < shortestDistance && !visitedCities.contains(entry.key)) {
      shortestCity = entry.key;
      shortestDistance = entry.value;
    }
  }

  return shortestCity!;
}

List<City> buildShortestPath(City end, Map<City, City> previousCities) {
  final List<City> path = [];

  City? currentCity = end;

  while (currentCity != null) {
    path.insert(0, currentCity);
    currentCity = previousCities[currentCity];
  }

  return path;
}

void main() {
  // Crear las ciudades
  City cityArmenia = City(name: "Armenia");
  City cityValledupar = City(name: "Valledupar");
  City cityBogota = City(name: "Bogotá");
  City cityBucaramanga = City(name: "Bucaramanga");
  City citySantaMarta = City(name: "Santa Marta");

  City cityBarranquilla = City(name: "Barranquilla");
  City cityMedellin = City(name: "Medellín");
  City cityCali = City(name: "Cali");

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

  citySantaMarta.seaConnections = [
    Connection(destination: cityBarranquilla, distance: 120),
  ];

  cityBarranquilla.seaConnections = [
    Connection(destination: citySantaMarta, distance: 120),
  ];

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

  // Ejecutar el algoritmo de Dijkstra considerando conexiones terrestres, aéreas, marítimas y por tren
  List<City> shortestPath = dijkstra(
    cityMedellin,
    cityBogota,
    includeAirConnections: false,
    includeSeaConnections: false,
    includeTrainConnections: true,
  );

  // Imprimir la ruta más corta
  print("Ruta más corta: ");
  for (City city in shortestPath) {
    print(city.name);
  }
}
