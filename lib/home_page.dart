import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:city_listing_app/il.dart';
import 'package:city_listing_app/ilce.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Il> _iller = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _jsonCozumle());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İller ve ilçeler"),
      ),
      body: ListView.builder(
        itemBuilder: ListBuilder, itemCount: _iller.length,),
    );
  }

  void _jsonCozumle() async {
    String jsonString =
    await rootBundle.loadString("assets/iller_ilceler.json");
    Map<String, dynamic> illerMap = json.decode(jsonString);
    for (String plakaKodu in illerMap.keys) {
      Map<String, dynamic> ilMap = illerMap[plakaKodu];
      String ilIsmi = ilMap["name"];
      Map<String, dynamic> ilceler = ilMap["districts"];
      List<Ilce> tumIlceler = [];
      for (String ilceKodu in ilceler.keys) {
        Map<String, dynamic> ilceMap = ilceler[ilceKodu];
        Ilce ilce = Ilce(ilceMap["name"]);
        tumIlceler.add(ilce);
      }
      Il il = Il(ilIsmi, plakaKodu, tumIlceler);
      _iller.add(il);
    }
    setState(() {});
  }

  Widget? ListBuilder(BuildContext context, int index) {
    return Card(
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_iller[index].name),
            Text(_iller[index].plaka)
          ],
        ),
        leading: Icon(Icons.location_city),
        children: _iller[index].ilceler.map((ilce){
          return ListTile(
            title: Text(ilce.name),
          );
        }).toList(),
      ),
    );
  }
}
