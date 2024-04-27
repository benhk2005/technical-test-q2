class Person {
  final String id;
  final String? lastName;
  final String? firstName;
  final String? email;
  final String? picture;
  final double? lat;
  final double? lng;

  Person({
    required this.id,
    this.lastName,
    this.firstName,
    this.email,
    this.picture,
    this.lat,
    this.lng,
  });

  String getName() {
    if (lastName != null && firstName != null) {
      return "$firstName $lastName";
    } else if (lastName != null) {
      return lastName ?? "";
    } else if (firstName != null) {
      return firstName ?? "";
    } else {
      return "";
    }
  }

  static Person? fromAPI(Map<String, dynamic> map) {
    final id = map["_id"] as String?;
    if (id != null) {
      final nameMap = map["name"] as Map<String, dynamic>?;
      final locationMap = map["location"] as Map<String, dynamic>?;
      return Person(
        id: id,
        lastName: nameMap?["last"],
        firstName: nameMap?["first"],
        email: map["email"],
        picture: map["picture"],
        lat: locationMap?["latitude"],
        lng: locationMap?["longitude"],
      );
    }
    return null;
  }
}
