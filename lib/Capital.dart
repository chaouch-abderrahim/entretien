
class Capital {
  String _name;
  String _country;
  String _population;
  double _lat;
  double _lng;

  Capital({
    required String name,
    required String country,
    required String population,
    required double lat,
    required double lng,
  })   : _name = name,
        _country = country,
        _population = population,
        _lat = lat,
        _lng = lng;

  // Getters
  String get name => _name;
  String get country => _country;
  String get population => _population;
  double get lat => _lat;
  double get lng => _lng;

  // Setters
  set name(String value) {
    _name = value;
  }

  set country(String value) {
    _country = value;
  }

  set population(String value) {
    _population = value;
  }

  set lat(double value) {
    _lat = value;
  }

  set lng(double value) {
    _lng = value;
  }
  // Méthode pour créer une instance de Capital à partir d'un objet JSON
  factory Capital.fromJson(Map<String, dynamic> json) {
    return Capital(
      name: json['name'],
      country: json['country'],
      population: json['population'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
  }

  // Méthode pour convertir l'objet Capital en un objet JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'population': population,
      'lat': lat,
      'lng': lng,
    };
  }
}