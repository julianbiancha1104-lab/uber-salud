class Provider {
  final String id, rut, fullName, specialty;
  final bool isVerified, isOnline;
  final double latitude, longitude, rating;

  Provider({
    required this.id, required this.rut, required this.fullName, 
    required this.specialty, this.isVerified = false, this.isOnline = false, 
    required this.latitude, required this.longitude, this.rating = 5.0,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'], rut: json['rut'], fullName: json['full_name'],
      specialty: json['specialty'], isVerified: json['is_verified_supersalud'] ?? false,
      isOnline: json['is_online'] ?? false, latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0, rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
    );
  }
}