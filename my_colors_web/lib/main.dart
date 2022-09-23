import 'package:flutter/material.dart';
import 'package:my_colors_web/api_service.dart';
import 'dart:math';

import 'package:my_colors_web/my_color.dart';

import 'utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'myColorsWeb',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'myColorsWeb'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _colorController = TextEditingController();
  final _countController = TextEditingController();

  Future<List<MyColor>> myColors = Future<List<MyColor>>.value([]);

  @override
  void initState() {
    super.initState();
    myColors = getColors("Random", "5");
  }

  @override
  void dispose() {
    super.dispose();
    _colorController.dispose();
    _countController.dispose();
  }

  Padding configColorGrid(List<MyColor> colors) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1 / .5,
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: colors.length,
            itemBuilder: (_, index) {
              return InkWell(
                onTap: () {},
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      color: MyColor.getColorFromHex(colors[index].hex)),
                  child: Center(
                      child: Text(
                    colors[index].hex,
                    style: const TextStyle(color: Colors.white),
                  )),
                ),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    var textFieldWidth = MediaQuery.of(context).size.width / 7;
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.title),
              const SizedBox(width: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textField(
                      width: textFieldWidth,
                      hintText: "Color",
                      controller: _colorController),
                  const SizedBox(width: 10),
                  textField(
                      width: textFieldWidth,
                      hintText: "Count",
                      controller: _countController),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            myColors = getColors(
                                _colorController.text, _countController.text);
                          });
                        },
                        child: const Text("Search")),
                  )
                ],
              )
            ],
          ),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Random"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Favorites"),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Info"),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Sign Out"),
                ),
              ];
            }, onSelected: (value) {
              switch (value) {
                case 0 /*Random*/ :
                  setState(() {
                    var random = "Random";
                    var randIntStr = Random().nextInt(51).toString();
                    _colorController.text = random;
                    _countController.text = randIntStr;
                    myColors = getColors(random, randIntStr);
                  });
                  break;
                case 1 /*Favorites*/ :
                  break;
                case 2 /*Info*/ :
                  break;
                case 3 /*SIgn Out*/ :
                  break;
              }
            }),
          ],
        ),
        body: FutureBuilder<List<MyColor>>(
          future: myColors,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return configColorGrid(snapshot.data!);
            } else if (snapshot.hasError) {
              return const Center(child: Icon(Icons.error));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
