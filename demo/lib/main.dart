import 'dart:async';
import 'package:demo/Assentos.dart';
import 'package:demo/convidados.dart';
import 'package:demo/grafico.dart';
import 'package:demo/sobre.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';

import 'model/evento.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

class Splash extends StatelessWidget {
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SplashScreen(
          seconds: 5,
          gradientBackground: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.pink[100],
              Colors.pink[300],
            ],
          ),
          navigateAfterSeconds: Autenticacao(),
          loaderColor: Colors.transparent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset("assets/images/logotipo.png",
                color: Colors.lime, width: 150, height: 150),
          ],
        ),
      ],
    );
  }
}

class Autenticacao extends StatefulWidget {
  @override
  _AutenticacaoState createState() => _AutenticacaoState();
}

class _AutenticacaoState extends State<Autenticacao> {
  var id = TextEditingController();

  String apiUrl =
      "http://192.168.1.100/gestevento/public/api/verEventoDecorrerAPI/";
  String info = 'OBS: Informe o Código do evento para aceder.';
  bool validate = false;
  String getEntidade = '';
  final box = GetStorage();

  Future<void> getEvento(var id) async {
    try {
      var apiTemp = apiUrl + id;
      var result = await http.get(apiTemp);
      if (result.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(result.body);
        Evento ev = Evento();
        ev.id = map['id'];
        ev.tipo = map['tipo'];
        ev.entidade = map['entidade'];
        ev.local = map['local'];
        ev.data = map['data'];
        ev.hora = map['hora'];

        memoryInsertDados(ev);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        setState(() {
          info = 'Nenhum evento encontrado.';
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> memoryInsertDados(Evento ev) async {
    box.write('m_id', ev.id.toString());
    box.write('m_tipo', ev.tipo);
    box.write('m_entidade', ev.entidade);
    box.write('m_local', ev.local);
    box.write('m_data', ev.data);
    box.write('m_hora', ev.hora);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pinkAccent[100],
          title:
              Image.asset("assets/images/logotopo.png", width: 150, height: 50),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(10, 100, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: id,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 15.0),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: 'Chave de Acesso',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(36.0)),
                  errorText:
                      validate ? 'O código de evento é obrigatório' : null,
                ),
              ),
              SizedBox(height: 20),
              RaisedButton(
                color: Colors.blueAccent,
                child: Text(
                  'ACEDER',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                onPressed: () {
                  setState(() {
                    id.text.isEmpty ? validate = true : validate = false;
                  });
                  if (!validate) {
                    getEvento(id.text);
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                info,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ));
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final box = GetStorage();
  String entidade;
  String tipo;
  String local;
  String data;
  String hora;

  void initState() {
    super.initState();
    entidade = box.read('m_entidade');
    tipo = box.read('m_tipo');
    local = box.read('m_local');
    data = box.read('m_data');
    hora = box.read('m_hora');
  }

  @override
  Widget build(BuildContext context) {
    final drawerItems = ListView(
      children: <Widget>[
        //drawerHeader,
        Container(
          height: 220,
          child: DrawerHeader(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "ENTIDADE",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  entidade,
                  style: TextStyle(color: Colors.black87),
                ),
                Divider(),
                Text(
                  "TIPO DE EVENTO",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  tipo,
                  style: TextStyle(color: Colors.black87),
                ),
                Divider(),
                Text(
                  "LOCAL",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  local,
                ),
                Divider(),
                Text(
                  "DATA",
                  style: TextStyle(color: Colors.white),
                ),
                Text.rich(
                  TextSpan(
                    text: data,
                    children: <TextSpan>[
                      TextSpan(
                        text: ' - ',
                      ),
                      TextSpan(
                        text: hora,
                      )
                    ],
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.pinkAccent[100],
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            margin: EdgeInsets.all(5),
          ),
        ),

        ListTile(
          title: Text('Inicio'),
          leading: Icon(Icons.home),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          },
        ),
        Divider(color: Colors.black38),
        ListTile(
          title: Text('Convidados'),
          leading: Icon(Icons.people),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Convidados()));
          },
        ),
        ListTile(
          title: Text('Assentos'),
          leading: Icon(Icons.table_chart),
          onTap: () {},
        ),
        ListTile(
          title: Text('Consumo'),
          leading: Icon(Icons.attach_money),
          onTap: () {},
        ),
        ListTile(
          title: Text('Estatísticas'),
          leading: Icon(Icons.insert_chart),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Grafico()));
          },
        ),
        Divider(color: Colors.black38),
        ListTile(
          title: Text('Sobre aplicativo'),
          leading: Icon(Icons.help),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Sobre()));
          },
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pinkAccent[100],
        title:
            Image.asset("assets/images/logotopo.png", width: 150, height: 50),
        //title: Text("GESTEVENTO",textAlign: TextAlign.end,style: TextStyle(color: Colors.yellow,fontSize: 20,fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        children: <Widget>[
          SizedBox(
            height: 200.0,
            width: 350.0,
            child: Carousel(
              images: [
                ExactAssetImage("assets/images/slide.jpg"),
                ExactAssetImage("assets/images/slide1.jpg"),
                ExactAssetImage("assets/images/slide2.jpg")
              ],
              dotSize: 5.0,
              dotSpacing: 15.0,
              dotColor: Colors.green,
              dotBgColor: Colors.black.withOpacity(0.5),
              moveIndicatorFromBottom: 100,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  ),
                  elevation: 3.0,
                  child: Container(
                    height: 120.0,
                    width: 120.0,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                            height: 120,
                            child: FlatButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/convidados.png",
                                    color: Colors.pinkAccent[100],
                                    width: 60,
                                    height: 60,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Convidados',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.pinkAccent),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Convidados()));
                              },
                            )),
                      ],
                    ),
                  )),
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  ),
                  elevation: 3.0,
                  child: Container(
                    height: 120.0,
                    width: 120.0,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                            height: 120,
                            child: FlatButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/assento.png",
                                    color: Colors.pinkAccent[100],
                                    width: 60,
                                    height: 60,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Assentos',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.pinkAccent),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Assentos()));
                              },
                            )),
                      ],
                    ),
                  )),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  ),
                  elevation: 3.0,
                  child: Container(
                    height: 120.0,
                    width: 120.0,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                            height: 120,
                            child: FlatButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/consumo.png",
                                    color: Colors.pinkAccent[100],
                                    width: 60,
                                    height: 60,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Consumo',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.pinkAccent),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Splash()));
                              },
                            )),
                      ],
                    ),
                  )),
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  ),
                  elevation: 3.0,
                  child: Container(
                    height: 120.0,
                    width: 120.0,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                            height: 120,
                            child: FlatButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/estatistica.png",
                                    color: Colors.pinkAccent[100],
                                    width: 60,
                                    height: 60,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Estatística',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.pinkAccent),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Grafico()));
                              },
                            )),
                      ],
                    ),
                  )),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: drawerItems,
      ),
    );
  }
}
