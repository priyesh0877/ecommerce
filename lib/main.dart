import 'dart:convert';
import 'package:ecommerce/productpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Myapp(),
  ));
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  bool c = false;
  List list = [];

  // ignore: non_constant_identifier_names
  gt_cat() async {
    var url = Uri.parse('https://dummyjson.com/products/categories');
    var response = await http.get(url);
    list = jsonDecode(response.body);
    c = true;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gt_cat();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text("category"),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                    ))
              ],
            ),
            drawer: Drawer(
                child: Column(
              children: [
                Container(
                  height: 230,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("image/sell.jpg"))),
                ),
                Container(
                  height: 711,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("image/back.jpg"))),
                  child: const Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "   More option",
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Icon(Icons.settings, size: 30, color: Colors.white),
                        Text(
                          "   Settings",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(Icons.star_rate, size: 30, color: Colors.white),
                        Text(
                          "   Rate us",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(Icons.share, size: 30, color: Colors.white),
                        Text(
                          "   Share",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ]),
                ),
              ],
            )),
            body: c == true
                ? ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("${list[index]}"),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return product(list[index]);
                            },
                          ));
                        },
                      );
                    },
                  )
                : const Center(
                    child:
                        CircularProgressIndicator(backgroundColor: Colors.red),
                  )));
  }
}
