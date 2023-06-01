import 'ciudad.dart';

class Maritimo {
  final String nombre;
  late List<ConnectionM> seaConnections;

  Maritimo({
    required this.nombre,
    List<ConnectionM>? seaConnections,
  }) {
    this.seaConnections = seaConnections ?? [];
  }
}

class ConnectionM {
  final Maritimo destination;
  final int distance;

  ConnectionM({required this.destination, required this.distance});
}

ShortestPathSeaResult dijkstraM(
  Maritimo start,
  Maritimo end,
) {
  final Map<Maritimo, int> distances = {};
  final Map<Maritimo, Maritimo> previousCities = {};
  final Set<Maritimo> visitedCities = <Maritimo>{};

  distances[start] = 0;

  while (visitedCities.length < distances.length) {
    Maritimo currentCity =
        getCityWithShortestDistance(distances, visitedCities);

    if (currentCity == end) {
      break; // Llegamos a la ciudad de destino, terminamos el algoritmo
    }

    visitedCities.add(currentCity);

    List<ConnectionM> connections = [];

    connections.addAll(currentCity.seaConnections);

    for (ConnectionM connection in connections) {
      int distance = distances[currentCity]! + connection.distance;

      if (!distances.containsKey(connection.destination) ||
          distance < distances[connection.destination]!) {
        distances[connection.destination] = distance;
        previousCities[connection.destination] = currentCity;
      }
    }
  }

  int totalDistance = 0; // Variable para acumular la suma de las distancias

  List<Maritimo> shortestPath = buildShortestPath(end, previousCities);
  for (int i = 0; i < shortestPath.length - 1; i++) {
    Maritimo currentCity = shortestPath[i];
    Maritimo nextCity = shortestPath[i + 1];
    List<ConnectionM> connections = currentCity.seaConnections;
    for (ConnectionM connection in connections) {
      if (connection.destination == nextCity) {
        totalDistance += connection.distance;
        break;
      }
    }
  }

  print("Suma de distancias del camino más corto: $totalDistance");

  return ShortestPathSeaResult(shortestPath, totalDistance);
}

Maritimo getCityWithShortestDistance(
    Map<Maritimo, int> distances, Set<Maritimo> visitedCities) {
  Maritimo? shortestCity;
  int shortestDistance = 99999;

  for (var entry in distances.entries) {
    if (entry.value < shortestDistance && !visitedCities.contains(entry.key)) {
      shortestCity = entry.key;
      shortestDistance = entry.value;
    }
  }

  return shortestCity!;
}

List<Maritimo> buildShortestPath(
    Maritimo end, Map<Maritimo, Maritimo> previousCities) {
  final List<Maritimo> path = [];

  Maritimo? currentCity = end;

  while (currentCity != null) {
    path.insert(0, currentCity);
    currentCity = previousCities[currentCity];
  }

  return path;
}

void main() {
  // Crear las ciudades
  Maritimo cityArmenia = Maritimo(nombre: "Armenia");
  Maritimo cityValledupar = Maritimo(nombre: "Valledupar");
  Maritimo cityBogota = Maritimo(nombre: "Bogotá");
  Maritimo cityBucaramanga = Maritimo(nombre: "Bucaramanga");
  Maritimo cityPereira = Maritimo(nombre: "Pereira");
  Maritimo cityBarranquilla = Maritimo(nombre: "Barranquilla");
  Maritimo cityMedellin = Maritimo(nombre: "Medellín");
  Maritimo cityCali = Maritimo(nombre: "Cali");
}
