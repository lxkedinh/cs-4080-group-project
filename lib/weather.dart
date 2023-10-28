import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Weather {
  final String city;
  final String region;
  final String country;
  final double temperature;
  final String condition;
  final String iconUri;

  const Weather(
      {required this.city,
      required this.region,
      required this.country,
      required this.temperature,
      required this.condition,
      required this.iconUri});

  factory Weather.fromJson(Map<String, dynamic> json) {
    var conditionIconUri = json['current']['condition']['icon'] as String;
    var s = conditionIconUri.split("/");
    var conditionTime = s[s.length - 2];
    var iconFile = s[s.length - 1];

    return Weather(
        city: json['location']['name'] as String,
        region: json['location']['region'] as String,
        country: json['location']['country'] as String,
        temperature: json['current']['temp_f'] as double,
        condition: json['current']['condition']['text'] as String,
        iconUri: 'assets/$conditionTime/$iconFile');
  }

  static Future<Weather> fetchWeather(String city) async {
    var response = await http.get(Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=${dotenv.env['API_KEY']}&q=$city&aqi=no'));

    if (response.statusCode == 200) {
      return Weather.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }

    throw Exception('Failed to fetch current weather.');
  }
}
