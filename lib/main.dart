import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:group_project/weather.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Weather App Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Weather>> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = Weather.fetchWeather("Pomona");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        onSearch: (String searchInput) {
          setState(() {
            if (searchInput!="") {
              futureWeather = Weather.fetchWeather(searchInput);
            }
          });
          return searchInput;
        },
      ),

      body: Center(
        child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white70,
            child: FutureBuilder<List<Weather>> (
              future: futureWeather,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(
                        snapshot.data![0].city,
                        style: const TextStyle(fontSize: 30,),
                      ),
                      const Divider(),
                      Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(snapshot.data![0].iconUri),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Currently: ${snapshot.data![0].currentTemp}"),
                                  Text("High: ${snapshot.data![0].highTemp}"),
                                  Text("Low: ${snapshot.data![0].lowTemp}"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      ListView.separated(
                        itemCount: snapshot.data!.length-1,
                        padding: const EdgeInsets.all(8),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                        itemBuilder: (context, index) {
                          return Row(
                            children: <Widget>[
                              Image.asset(snapshot.data![index+1].iconUri),
                              Column(
                                children: [
                                  Text(
                                    snapshot.data![index+1].date,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("High: ${snapshot.data![index+1].highTemp}"),
                                  Text("Low: ${snapshot.data![index+1].lowTemp}"),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const Divider(),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            )
        ),
      ),
    );
  }
}
