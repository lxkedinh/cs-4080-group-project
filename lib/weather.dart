import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Weather {
  final String city;
  final String region;
  final String country;
  final double currentTemp;
  final double highTemp;
  final double lowTemp;
  final String date;
  final String condition;
  final String iconUri;

  const Weather(
      {required this.city,
      required this.region,
      required this.country,
      required this.currentTemp,
      required this.highTemp,
      required this.lowTemp,
      required this.date,
      required this.condition,
      required this.iconUri});

  factory Weather.current(Map<String, dynamic> json) {
    var conditionIconUri = json['current']['condition']['icon'] as String;
    var s = conditionIconUri.split("/");
    var conditionTime = s[s.length - 2];
    var iconFile = s[s.length - 1];
    var location = json['location'];

    return Weather(
        city: location['name'] as String,
        region: location['region'] as String,
        country: location['country'] as String,
        currentTemp: json['current']['temp_f'] as double,
        highTemp:
            json['forecast']['forecastday'][0]['day']['maxtemp_f'] as double,
        lowTemp:
            json['forecast']['forecastday'][0]['day']['mintemp_f'] as double,
        date: json['forecast']['forecastday'][0]['date'],
        condition: json['current']['condition']['text'] as String,
        iconUri: 'assets/$conditionTime/$iconFile');
  }

  factory Weather.forecast(Map<String, dynamic> json, int offset) {
    var forecast = json['forecast']['forecastday'][offset];
    var location = json['location'];

    var conditionIconUri = forecast['day']['condition']['icon'] as String;
    var s = conditionIconUri.split("/");
    var conditionTime = s[s.length - 2];
    var iconFile = s[s.length - 1];

    return Weather(
        city: location['name'] as String,
        region: location['region'] as String,
        country: location['country'] as String,
        currentTemp: json['current']['temp_f'] as double,
        highTemp: forecast['day']['maxtemp_f'] as double,
        lowTemp: forecast['day']['mintemp_f'] as double,
        date: forecast['date'],
        condition: json['current']['condition']['text'] as String,
        iconUri: 'assets/$conditionTime/$iconFile');
  }

  static Future<List<Weather>> fetchWeather(String city) async {
    var response = await http.get(Uri.parse(
        'https://api.weatherapi.com/v1/forecast.json?key=${dotenv.env['API_KEY']}&q=$city&days=3&aqi=no&alerts=no'));

    if (response.statusCode == 200) {
      List<Weather> weatherForecast = [];
      var json = jsonDecode(response.body) as Map<String, dynamic>;
      weatherForecast.add(Weather.current(json));

      for (var i = 1; i < 3; i++) {
        weatherForecast.add(Weather.forecast(json, i));
      }

      return weatherForecast;
    }

    throw Exception('Failed to fetch current weather.');
  }
}
