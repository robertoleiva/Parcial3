import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:parcial3/modulos/Starwar.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(Api3());
}

class Api3 extends StatefulWidget {
  @override
  State<Api3> createState() => _Api3State();
}

class _Api3State extends State<Api3> {
  late Future<List<Starwar>> _listadoStarwar;

  Future<List<Starwar>> _getStarwar() async {
    final response = await http
        .get(Uri.parse("https://swapi.dev/api/people/")); //https://swapi.dev/
    
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final jsonStarwar = jsonResponse['results'];
      //print(jsonStarwar[0]['name']);
      List<Starwar> lista = []; // Se crear el vector y se llaman los campos del Json
      for (var item in jsonStarwar) {
        lista.add(Starwar(
            item["name"], item["height"], item["mass"], item["hair_color"], item["gender"]));
            print(item["name"]);
      }
      return lista;
    } else {
      throw Exception('Failed to load Starwar');
    }

  }

  void initState() {
    super.initState();
    _listadoStarwar = _getStarwar();
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: _listadoStarwar,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: _listadoStarwars(snapshot.data),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("Error");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'APIS-STARWAR',
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('Bienvenidos a STARWAR', style: TextStyle(color: Colors.yellow, fontSize: 20, fontWeight: FontWeight.bold),),
          ),
          body: futureBuilder, backgroundColor: Colors.greenAccent,),
    );
  }

  List<Widget> _listadoStarwars(data) {
    List<Widget> wars = [];
    for (var itemst in data) {
      wars.add(Card(
        elevation: 2.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextField(
              enabled: false,
              decoration: InputDecoration(
                border: InputBorder.none,
               
                hintText: 'Grupo de Gabriel Diaz y Roberto Leiva',
              ),
            ),
            Container(
              padding: EdgeInsets.all(2.0),
              height: 220,
              width: 600,
              decoration: BoxDecoration(
               
              color: Colors.pinkAccent,
                
                
                 image: DecorationImage(
                  image: NetworkImage('https://studiosol-a.akamaihd.net/uploadfile/letras/playlists/b/f/e/e/bfee9db6b8ef49469dff970091a6e72f.jpg'), scale: 1, fit: BoxFit.cover), 
                
              ),
            ),
            Text("Nombre: "+itemst.name, style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),),
            Text("Altura: "+itemst.height+" cm", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
            Text("Peso: "+itemst.mass+" kg", style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),),
            Text("Cabello: "+itemst.hair_color, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
            Text("Genero: "+itemst.gender, style: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold),),
          ],
        ),
        
      ));
    }
    return wars;
  }
}