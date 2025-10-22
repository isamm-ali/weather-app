import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather/AdditionalInfo.dart';
import 'package:weather/forecast.dart';
import 'package:weather/api.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double temp = 0;
  String currentsky = "";
  String pressure = "";
  double wind = 0;
  int humidity = 0;
  List<dynamic> forecastData = [];

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    final res = await http.get(Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast?q=Kolkata&appid=$apikey&units=metric",
    ));

    final data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        temp = (data["list"][0]["main"]["temp"]).toDouble();
        currentsky = data["list"][0]["weather"][0]["main"];
        pressure = (data["list"][0]["main"]["pressure"]).toString();
        wind = (data["list"][0]["wind"]["speed"]).toDouble();
        humidity = (data["list"][0]["main"]["humidity"]).toInt();
        forecastData = data["list"];
      });
    } else {
      print("Request failed: ${res.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(5, 2, 7, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(5, 2, 7, 1),
          title: const Text(
            "𝚆𝚎𝚊𝚝𝚑𝚎𝚛 - 𝙺𝚘𝚕𝚔𝚊𝚝𝚊",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: getCurrentWeather,
              icon: const Icon(Icons.refresh, color: Colors.white),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: const Color.fromRGBO(214, 185, 252, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                  shadowColor: const Color.fromRGBO(214, 185, 252, 1),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        (temp == 0) ? "Loading..." : "$temp°C",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Icon(
                        (currentsky == "Clear")
                            ? Icons.sunny
                            : Icons.cloud,
                        size: 70,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        currentsky,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Weather Forecast",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (forecastData.isNotEmpty)
                      for (int i = 1; i < 6; i++)
                        forecast(
                          time: forecastData[i]["dt_txt"].toString().substring(11, 16),
                          icon: (forecastData[i]["weather"][0]["main"] == "Clear")
                              ? Icons.sunny
                              : Icons.cloud,
                          temp:
                          "${forecastData[i]["main"]["temp"].toString()}°C",
                        )
                    else
                      const Text(
                        "Loading forecast...",
                        style: TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Additional Information",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfo(
                    icon: Icons.water_drop,
                    label: "Humidity",
                    value: humidity.toString(),
                  ),
                  AdditionalInfo(
                    icon: Icons.air,
                    label: "Wind Speed",
                    value: wind.toString(),
                  ),
                  AdditionalInfo(
                    icon: Icons.beach_access,
                    label: "Pressure",
                    value: pressure,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
