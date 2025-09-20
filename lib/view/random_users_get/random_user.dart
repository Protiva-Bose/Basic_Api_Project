import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RandomUserResponse {
  final List<UserResult> results;
  final Info info;

  RandomUserResponse({required this.results, required this.info});

  factory RandomUserResponse.fromJson(Map<String, dynamic> json) {
    return RandomUserResponse(
      results: (json['results'] as List)
          .map((e) => UserResult.fromJson(e))
          .toList(),
      info: Info.fromJson(json['info']),
    );
  }
}

class UserResult {
  final String gender;
  final Name name;
  final Location location;
  final String email;
  final Login login;
  final Dob dob;
  final Registered registered;
  final String phone;
  final String cell;
  final Id id;
  final Picture picture;
  final String nat;

  UserResult({
    required this.gender,
    required this.name,
    required this.location,
    required this.email,
    required this.login,
    required this.dob,
    required this.registered,
    required this.phone,
    required this.cell,
    required this.id,
    required this.picture,
    required this.nat,
  });

  factory UserResult.fromJson(Map<String, dynamic> json) {
    return UserResult(
      gender: json['gender'],
      name: Name.fromJson(json['name']),
      location: Location.fromJson(json['location']),
      email: json['email'],
      login: Login.fromJson(json['login']),
      dob: Dob.fromJson(json['dob']),
      registered: Registered.fromJson(json['registered']),
      phone: json['phone'],
      cell: json['cell'],
      id: Id.fromJson(json['id']),
      picture: Picture.fromJson(json['picture']),
      nat: json['nat'],
    );
  }
}

class Name {
  final String title;
  final String first;
  final String last;

  Name({required this.title, required this.first, required this.last});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(title: json['title'], first: json['first'], last: json['last']);
  }
}

class Location {
  final Street street;
  final String city;
  final String state;
  final String country;
  final dynamic postcode;
  final Coordinates coordinates;
  final Timezone timezone;

  Location({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.coordinates,
    required this.timezone,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      street: Street.fromJson(json['street']),
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postcode: json['postcode'],
      coordinates: Coordinates.fromJson(json['coordinates']),
      timezone: Timezone.fromJson(json['timezone']),
    );
  }
}

class Street {
  final int number;
  final String name;

  Street({required this.number, required this.name});

  factory Street.fromJson(Map<String, dynamic> json) {
    return Street(number: json['number'], name: json['name']);
  }
}

class Coordinates {
  final String latitude;
  final String longitude;

  Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class Timezone {
  final String offset;
  final String description;

  Timezone({required this.offset, required this.description});

  factory Timezone.fromJson(Map<String, dynamic> json) {
    return Timezone(offset: json['offset'], description: json['description']);
  }
}

class Login {
  final String uuid;
  final String username;
  final String password;
  final String salt;
  final String md5;
  final String sha1;
  final String sha256;

  Login({
    required this.uuid,
    required this.username,
    required this.password,
    required this.salt,
    required this.md5,
    required this.sha1,
    required this.sha256,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      uuid: json['uuid'],
      username: json['username'],
      password: json['password'],
      salt: json['salt'],
      md5: json['md5'],
      sha1: json['sha1'],
      sha256: json['sha256'],
    );
  }
}

class Dob {
  final String date;
  final int age;

  Dob({required this.date, required this.age});

  factory Dob.fromJson(Map<String, dynamic> json) {
    return Dob(date: json['date'], age: json['age']);
  }
}

class Registered {
  final String date;
  final int age;

  Registered({required this.date, required this.age});

  factory Registered.fromJson(Map<String, dynamic> json) {
    return Registered(date: json['date'], age: json['age']);
  }
}

class Id {
  final String? name;
  final String? value;

  Id({this.name, this.value});

  factory Id.fromJson(Map<String, dynamic> json) {
    return Id(name: json['name'], value: json['value']);
  }
}

class Picture {
  final String large;
  final String medium;
  final String thumbnail;

  Picture({required this.large, required this.medium, required this.thumbnail});

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      large: json['large'],
      medium: json['medium'],
      thumbnail: json['thumbnail'],
    );
  }
}

class Info {
  final String seed;
  final int results;
  final int page;
  final String version;

  Info({
    required this.seed,
    required this.results,
    required this.page,
    required this.version,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      seed: json['seed'],
      results: json['results'],
      page: json['page'],
      version: json['version'],
    );
  }
}

class RandomUser extends StatefulWidget {
  const RandomUser({super.key});

  @override
  State<RandomUser> createState() => _RandomUserState();
}

class _RandomUserState extends State<RandomUser> {
  List<UserResult> user = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Uri uri = Uri.parse('https://randomuser.me/api/?results=5');

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    print('Response... ++++++++++++++ ${response.statusCode}');
    print('Response... ${response.body}');

    if (response.statusCode == 200) {
      final data = RandomUserResponse.fromJson(jsonDecode(response.body));
      setState(() {
        user = data.results;
      });
    } else {
      throw Exception('Failed to lea data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('For single user')),
      backgroundColor: Colors.blue[200],
      body: user.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(user[index].name.first),
            subtitle: Text(user[index].email),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user[index].picture.thumbnail),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: user.length,
      ),
    );
  }
}
