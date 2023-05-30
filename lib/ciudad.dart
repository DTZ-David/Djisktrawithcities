class City {
  final String name;
  late List<Connection> connections;

  City({required this.name, required this.connections});
}

class Connection {
  final City destination;
  final int distance;

  Connection({required this.destination, required this.distance});
}

List<City> dijkstra(City start, City end) {
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

    for (Connection connection in currentCity.connections) {
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
  City cityArmenia = City(name: "Armenia", connections: []);
  City cityValledupar = City(name: "Valledupar", connections: []);
  City cityBogota = City(name: "Bogotá", connections: []);
  City cityBucaramanga = City(name: "Bucaramanga", connections: []);
  City cityCartagena = City(name: "Cartagena", connections: []);
  City cityPereira = City(name: "Pereira", connections: []);
  City cityBarranquilla = City(name: "Barranquilla", connections: []);
  City cityMedellin = City(name: "Medellín", connections: []);
  City cityCali = City(name: "Cali", connections: []);

  // Crear las conexiones entre ciudades
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

  // Ejecutar el algoritmo de Dijkstra
  List<City> shortestPath = dijkstra(cityMedellin, cityValledupar);

  // Imprimir la ruta más corta
  print("Ruta más corta: ");
  for (City city in shortestPath) {
    print(city.name);
  }
}
