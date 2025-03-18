class UserAddress {
  final int id;
  final String address;
  final String? label;
  final dynamic longitude;
  final dynamic latitude;
  final bool primary;
  final String? plusCode;

  UserAddress(
      {required this.id,
      required this.address,
      required this.label,
      required this.longitude,
      required this.latitude,
      this.primary = false,
      this.plusCode});

  // Convert UserAddress to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'label': label,
      'longitude': longitude,
      'latitude': latitude,
      'primary': primary,
      'plus_code': plusCode
    };
  }

  // Create a UserAddress from a JSON map
  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'],
      address: json['address'],
      label: json['label'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      primary: json['primary'] ?? false,
      plusCode: json['plus_code'],
    );
  }

  UserAddress copyWith({
    int? id,
    String? street,
    String? city,
    String? longitude,
    String? latitude,
    bool? primary,
    String? plusCode,
  }) {
    return UserAddress(
        id: id ?? this.id,
        address: address,
        label: label ?? this.label,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        primary: primary ?? this.primary,
        plusCode: plusCode ?? this.plusCode);
  }
}
