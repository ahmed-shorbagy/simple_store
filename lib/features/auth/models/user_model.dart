import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String email;
  final String username;
  final String token;
  final UserName name;
  final UserAddress address;
  final String phone;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.token,
    required this.name,
    required this.address,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String token) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      token: token,
      name: UserName.fromJson(json['name'] as Map<String, dynamic>),
      address: UserAddress.fromJson(json['address'] as Map<String, dynamic>),
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'token': token,
      'name': name.toJson(),
      'address': address.toJson(),
      'phone': phone,
    };
  }

  @override
  List<Object?> get props => [id, email, username, token, name, address, phone];
}

class UserName extends Equatable {
  final String firstname;
  final String lastname;

  const UserName({
    required this.firstname,
    required this.lastname,
  });

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
    };
  }

  String get fullName => '$firstname $lastname';

  @override
  List<Object?> get props => [firstname, lastname];
}

class UserAddress extends Equatable {
  final String city;
  final String street;
  final int number;
  final String zipcode;
  final GeoLocation geolocation;

  const UserAddress({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    required this.geolocation,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      city: json['city'] as String,
      street: json['street'] as String,
      number: json['number'] as int,
      zipcode: json['zipcode'] as String,
      geolocation:
          GeoLocation.fromJson(json['geolocation'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'number': number,
      'zipcode': zipcode,
      'geolocation': geolocation.toJson(),
    };
  }

  String get fullAddress => '$number $street, $city, $zipcode';

  @override
  List<Object?> get props => [city, street, number, zipcode, geolocation];
}

class GeoLocation extends Equatable {
  final String lat;
  final String long;

  const GeoLocation({
    required this.lat,
    required this.long,
  });

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      lat: json['lat'] as String,
      long: json['long'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'long': long,
    };
  }

  @override
  List<Object?> get props => [lat, long];
}
