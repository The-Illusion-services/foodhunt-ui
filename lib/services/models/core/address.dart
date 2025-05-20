class UserAddress {
  final int? id;
  final String address;
  final String street;
  final String houseNumber;
  final String state;
  final String landmark;
  final String? label;
  final dynamic longitude;
  final dynamic latitude;
  final bool primary;
  final String? plusCode;

  UserAddress({
    this.id,
    required this.address,
    required this.street,
    required this.houseNumber,
    required this.state,
    required this.landmark,
    this.label,
    required this.longitude,
    required this.latitude,
    this.primary = false,
    this.plusCode,
  });

  // Convert UserAddress to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'street': street,
      'house_number': houseNumber,
      'state': state,
      'landmark': landmark,
      'label': label,
      'longitude': longitude,
      'latitude': latitude,
      'primary': primary,
      'plus_code': plusCode,
    };
  }

  // Create a UserAddress from a JSON map
  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'],
      address: json['address'],
      street: json['street'],
      houseNumber: json['house_number'],
      state: json['state'],
      landmark: json['landmark'],
      label: json['label'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      primary: json['primary'] ?? false,
      plusCode: json['plus_code'],
    );
  }

  UserAddress copyWith({
    int? id,
    String? address,
    String? street,
    String? houseNumber,
    String? state,
    String? landmark,
    String? label,
    dynamic longitude,
    dynamic latitude,
    bool? primary,
    String? plusCode,
  }) {
    return UserAddress(
      id: id ?? this.id,
      address: address ?? this.address,
      street: street ?? this.street,
      houseNumber: houseNumber ?? this.houseNumber,
      state: state ?? this.state,
      landmark: landmark ?? this.landmark,
      label: label ?? this.label,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      primary: primary ?? this.primary,
      plusCode: plusCode ?? this.plusCode,
    );
  }
}
