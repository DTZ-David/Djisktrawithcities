import 'ciudad.dart';

class Tren {
  final String nombre;
  late List<ConnectionT> trainConnections;

  Tren({
    required this.nombre,
    List<ConnectionT>? trainConnections,
  }) {
    this.trainConnections = trainConnections ?? [];
  }
}

class ConnectionT {
  final Tren destination;
  final int distance;

  ConnectionT({required this.destination, required this.distance});
}

ShortestPathTrainaResult dijkstraTrain(
  Tren start,
  Tren end,
) {
  final Map<Tren, int> distances = {};
  final Map<Tren, Tren> previousCities = {};
  final Set<Tren> visitedCities = <Tren>{};

  distances[start] = 0;

  while (visitedCities.length < distances.length) {
    Tren currentCity = getCityWithShortestDistance(distances, visitedCities);

    if (currentCity == end) {
      break; // Llegamos a la ciudad de destino, terminamos el algoritmo
    }

    visitedCities.add(currentCity);

    List<ConnectionT> connections = [];

    connections.addAll(currentCity.trainConnections);

    for (ConnectionT connection in connections) {
      int distance = distances[currentCity]! + connection.distance;

      if (!distances.containsKey(connection.destination) ||
          distance < distances[connection.destination]!) {
        distances[connection.destination] = distance;
        previousCities[connection.destination] = currentCity;
      }
    }
  }

  int totalDistance = 0; // Variable para acumular la suma de las distancias

  List<Tren> shortestPath = buildShortestPath(end, previousCities);
  for (int i = 0; i < shortestPath.length - 1; i++) {
    Tren currentCity = shortestPath[i];
    Tren nextCity = shortestPath[i + 1];
    List<ConnectionT> connections = currentCity.trainConnections;
    for (ConnectionT connection in connections) {
      if (connection.destination == nextCity) {
        totalDistance += connection.distance;
        break;
      }
    }
  }

  print("Suma de distancias del camino más corto: $totalDistance");

  return ShortestPathTrainaResult(shortestPath, totalDistance);
}

Tren getCityWithShortestDistance(
    Map<Tren, int> distances, Set<Tren> visitedCities) {
  Tren? shortestCity;
  int shortestDistance = 99999;

  for (var entry in distances.entries) {
    if (entry.value < shortestDistance && !visitedCities.contains(entry.key)) {
      shortestCity = entry.key;
      shortestDistance = entry.value;
    }
  }

  return shortestCity!;
}

List<Tren> buildShortestPath(Tren end, Map<Tren, Tren> previousCities) {
  final List<Tren> path = [];

  Tren? currentCity = end;

  while (currentCity != null) {
    path.insert(0, currentCity);
    currentCity = previousCities[currentCity];
  }

  return path;
}

void main() {
  // Crear las ciudades
  Tren cityArmenia = Tren(nombre: "Armenia");
  Tren cityValledupar = Tren(nombre: "Valledupar");
  Tren cityBogota = Tren(nombre: "Bogotá");
  Tren cityBucaramanga = Tren(nombre: "Bucaramanga");
  Tren cityPereira = Tren(nombre: "Pereira");
  Tren cityBarranquilla = Tren(nombre: "Barranquilla");
  Tren cityMedellin = Tren(nombre: "Medellín");
  Tren cityCali = Tren(nombre: "Cali");
}
