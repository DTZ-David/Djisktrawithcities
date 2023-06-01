import 'package:djkistra_01/maritimo.dart';
import 'package:djkistra_01/tren.dart';
import 'package:djkistra_01/vuelos.dart';

class City {
  final String name;
  late List<Connection> landConnections;

  City({
    required this.name,
    List<Connection>? landConnections,
  }) {
    this.landConnections = landConnections ?? [];
  }
}

class ShortestPathCityResult {
  final List<City> shortestPath;
  final int totalDistance;

  ShortestPathCityResult(this.shortestPath, this.totalDistance);
}

class ShortestPathFlyResult {
  final List<Vuelo> shortestPath;
  final int totalDistance;

  ShortestPathFlyResult(this.shortestPath, this.totalDistance);
}

class ShortestPathSeaResult {
  final List<Maritimo> shortestPath;
  final int totalDistance;

  ShortestPathSeaResult(this.shortestPath, this.totalDistance);
}

class ShortestPathTrainaResult {
  final List<Tren> shortestPath;
  final int totalDistance;

  ShortestPathTrainaResult(this.shortestPath, this.totalDistance);
}

class Connection {
  final City destination;
  final int distance;

  Connection({required this.destination, required this.distance});
}

ShortestPathCityResult dijkstraT(
  City start,
  City end,
) {
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

    List<Connection> connections = [];

    connections.addAll(currentCity.landConnections);

    for (Connection connection in connections) {
      int distance = distances[currentCity]! + connection.distance;

      if (!distances.containsKey(connection.destination) ||
          distance < distances[connection.destination]!) {
        distances[connection.destination] = distance;
        previousCities[connection.destination] = currentCity;
      }
    }
  }

  int totalDistance = 0; // Variable para acumular la suma de las distancias

  List<City> shortestPath = buildShortestPath(end, previousCities);
  for (int i = 0; i < shortestPath.length - 1; i++) {
    City currentCity = shortestPath[i];
    City nextCity = shortestPath[i + 1];
    List<Connection> connections = currentCity.landConnections;
    for (Connection connection in connections) {
      if (connection.destination == nextCity) {
        totalDistance += connection.distance;
        break;
      }
    }
  }

  print("Suma de distancias del camino más corto: $totalDistance");

  return ShortestPathCityResult(shortestPath, totalDistance);
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
  City cityPereira = City(name: "Pereira");
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

  ShortestPathCityResult result = dijkstraT(cityBarranquilla, cityCali);

  List<City> shortestPath = result.shortestPath;
  int totalDistance = result.totalDistance;

  print("Ruta más corta: ");
  for (City city in shortestPath) {
    print(city.name);
  }
}
