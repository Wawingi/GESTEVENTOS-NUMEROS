import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Convidados extends StatefulWidget {
  @override
  _ConvidadosState createState() => _ConvidadosState();
}

class _ConvidadosState extends State<Convidados> {
  final String apiUrl =
      "http://192.168.1.100/gestevento/public/api/convidados/";
  final box = GetStorage();
  String idEvento;

  void initState() {
    super.initState();
    idEvento = box.read('m_id');
  }

  Future<List<dynamic>> pegaConvidados() async {
    var result = await http.get(apiUrl + idEvento);
    return json.decode(result.body)['data'];
  }

  String nome(dynamic user) {
    return user['nome'];
  }

  String assento(dynamic user) {
    return user['assento'];
  }

  String acompanhante(dynamic user) {
    return user['acompanhante'];
  }

  String estado(dynamic user) {
    return user['estado'];
  }

  String updated_at(dynamic user) {
    String data = user['updated_at'];
    if (user['estado'] == "Presente") {
      var corte = data.split(" ");
      return corte[1];
    } else {
      return data;
    }
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
          future: pegaConvidados(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                        ListTile(
                          leading: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/conv.png",
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
                                  text: 'Convidado: ',
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: nome(snapshot.data[index]),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.grey),
                              Text.rich(
                                TextSpan(
                                  text: 'Acompanhante: ',
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            acompanhante(snapshot.data[index]),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.grey),
                              Text.rich(
                                TextSpan(
                                  text: 'Assento: ',
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: assento(snapshot.data[index]),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.grey),
                              if (estado(snapshot.data[index]) == "Ausente")
                                Text.rich(
                                  TextSpan(
                                    text: 'Estado: ',
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: estado(snapshot.data[index]),
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              if (estado(snapshot.data[index]) == "Presente")
                                Text.rich(
                                  TextSpan(
                                    text: 'Estado: ',
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: estado(snapshot.data[index]),
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              Divider(color: Colors.grey),
                              Text.rich(
                                TextSpan(
                                  text: 'Hora Chegada: ',
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: updated_at(snapshot.data[index]),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
