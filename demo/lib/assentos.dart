import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Assentos extends StatefulWidget {
  @override
  _AssentosState createState() => _AssentosState();
}

class _AssentosState extends State<Assentos> {
  final String apiUrl =
      "http://192.168.1.100/gestevento/public/api/verAssentoDecorrerAPI/";
  final box = GetStorage();
  String idEvento;
  bool isAssento = true;

  void initState() {
    super.initState();
    idEvento = box.read('m_id');
  }

  Future<List<dynamic>> pegaAssentos() async {
    var result = await http.get(apiUrl + idEvento);
    return json.decode(result.body)['data'];
  }

  String designacao(dynamic assento) {
    return assento['designacao'];
  }

  String capacidade(dynamic assento) {
    return assento['capacidade'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pinkAccent[100],
        title:
            Image.asset("assets/images/logotopo.png", width: 150, height: 50),
        //title: Text("GESTEVENTO",textAlign: TextAlign.end,style: TextStyle(color: Colors.yellow,fontSize: 20,fontWeight: FontWeight.bold)),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: pegaAssentos(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (isAssento) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 2.0,
                      shadowColor: Colors.pinkAccent,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            leading: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(
                                  "assets/images/assento.png",
                                  color: Colors.brown,
                                  width: 60,
                                  height: 200,
                                ),
                              ],
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    text: 'Designação: ',
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              designacao(snapshot.data[index]),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: 'Capacidade: ',
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              capacidade(snapshot.data[index]),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
