import 'ciudad.dart';

class Vuelo {
  final String nombre;
  late List<ConnectionV> airConnections;

  Vuelo({
    required this.nombre,
    List<ConnectionV>? airConnections,
  }) {
    this.airConnections = airConnections ?? [];
  }
}

class ConnectionV {
  final Vuelo destination;
  final int distance;

  ConnectionV({required this.destination, required this.distance});
}

ShortestPathFlyResult dijkstraV(
  Vuelo start,
  Vuelo end,
) {
  final Map<Vuelo, int> distances = {};
  final Map<Vuelo, Vuelo> previousCities = {};
  final Set<Vuelo> visitedCities = <Vuelo>{};

  distances[start] = 0;

  while (visitedCities.length < distances.length) {
    Vuelo currentCity = getCityWithShortestDistance(distances, visitedCities);

    if (currentCity == end) {
      break; // Llegamos a la ciudad de destino, terminamos el algoritmo
    }

    visitedCities.add(currentCity);

    List<ConnectionV> connections = [];

    connections.addAll(currentCity.airConnections);

    for (ConnectionV connection in connections) {
      int distance = distances[currentCity]! + connection.distance;

      if (!distances.containsKey(connection.destination) ||
          distance < distances[connection.destination]!) {
        distances[connection.destination] = distance;
        previousCities[connection.destination] = currentCity;
      }
    }
  }

  int totalDistance = 0; // Variable para acumular la suma de las distancias

  List<Vuelo> shortestPath = buildShortestPath(end, previousCities);
  for (int i = 0; i < shortestPath.length - 1; i++) {
    Vuelo currentCity = shortestPath[i];
    Vuelo nextCity = shortestPath[i + 1];
    List<ConnectionV> connections = currentCity.airConnections;
    for (ConnectionV connection in connections) {
      if (connection.destination == nextCity) {
        totalDistance += connection.distance;
        break;
      }
    }
  }

  print("Suma de distancias del camino más corto: $totalDistance");

  return ShortestPathFlyResult(shortestPath, totalDistance);
}

Vuelo getCityWithShortestDistance(
    Map<Vuelo, int> distances, Set<Vuelo> visitedCities) {
  Vuelo? shortestCity;
  int shortestDistance = 99999;

  for (var entry in distances.entries) {
    if (entry.value < shortestDistance && !visitedCities.contains(entry.key)) {
      shortestCity = entry.key;
      shortestDistance = entry.value;
    }
  }

  return shortestCity!;
}

List<Vuelo> buildShortestPath(Vuelo end, Map<Vuelo, Vuelo> previousCities) {
  final List<Vuelo> path = [];

  Vuelo? currentCity = end;

  while (currentCity != null) {
    path.insert(0, currentCity);
    currentCity = previousCities[currentCity];
  }

  return path;
}

void main() {
  // Crear las ciudades
  Vuelo cityArmenia = Vuelo(nombre: "Armenia");
  Vuelo cityValledupar = Vuelo(nombre: "Valledupar");
  Vuelo cityBogota = Vuelo(nombre: "Bogotá");
  Vuelo cityBucaramanga = Vuelo(nombre: "Bucaramanga");
  Vuelo cityPereira = Vuelo(nombre: "Pereira");
  Vuelo cityBarranquilla = Vuelo(nombre: "Barranquilla");
  Vuelo cityMedellin = Vuelo(nombre: "Medellín");
  Vuelo cityCali = Vuelo(nombre: "Cali");

  // Crear las conexiones terrestres entre ciudades

  // Crear las conexiones aéreas entre ciudades
  // Agregar conexiones aéreas adicionales entre ciudades
  cityArmenia.airConnections = [
    ConnectionV(destination: cityValledupar, distance: 350),
    ConnectionV(destination: cityMedellin, distance: 300),
  ];

  cityValledupar.airConnections = [
    ConnectionV(destination: cityArmenia, distance: 350),
    ConnectionV(destination: cityBogota, distance: 400),
  ];

  cityBogota.airConnections = [
    ConnectionV(destination: cityValledupar, distance: 400),
    ConnectionV(destination: cityCali, distance: 350),
  ];

  cityBucaramanga.airConnections = [
    ConnectionV(destination: cityMedellin, distance: 250),
    ConnectionV(destination: cityCali, distance: 400),
  ];

  cityPereira.airConnections = [
    ConnectionV(destination: cityBarranquilla, distance: 450),
    ConnectionV(destination: cityMedellin, distance: 150),
  ];

  cityBarranquilla.airConnections = [
    ConnectionV(destination: cityPereira, distance: 450),
    ConnectionV(destination: cityBogota, distance: 500),
  ];

  cityMedellin.airConnections = [
    ConnectionV(destination: cityArmenia, distance: 300),
    ConnectionV(destination: cityBucaramanga, distance: 250),
    ConnectionV(destination: cityPereira, distance: 40),
  ];

  cityCali.airConnections = [
    ConnectionV(destination: cityBogota, distance: 350),
    ConnectionV(destination: cityBucaramanga, distance: 400),
  ];

  // Crear las conexiones marítimas entre ciudades

  // Crear las conexiones por tren entre ciudades

  // Ejecutar el algoritmo de Dijkstra considerando conexiones terrestres, aéreas, marítimas y por tren
}
