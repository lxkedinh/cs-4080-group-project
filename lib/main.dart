import 'package:flutter/material.dart';
import 'custom_search_delegate.dart';

void main() {
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        // Search button, opens search bar menu
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: CustomSearchDelegate()
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),

      // TODO remove placeholder text/icon, update from API
      body: Center(
        child: Column(
          children: <Widget>[
            // Container for current weather
            Container(
              padding: const EdgeInsets.all(8),
              height: 150,
              color: Colors.white70,
              child: const Row (
                children: <Widget>[
                  Icon(
                    Icons.sunny
                  ),
                  Text('Current Weather')
                ],
              )
            ),

            // List of the weather report for the next week
            Expanded(child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: 7,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  color: Colors.white12,
                  child: const Row (
                    children: <Widget>[
                      Icon(
                          Icons.sunny
                      ),
                      Text('Day')
                    ],
                  )
                );
              },)
            )

          ],
        ),
      ),
    );
  }
}