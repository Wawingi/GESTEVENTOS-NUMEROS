import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Sobre extends StatefulWidget {
  @override
  _SobreState createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
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
        padding: EdgeInsets.fromLTRB(20, 50, 20, 100),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          color: Colors.white,
          elevation: 10.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 15),
              Image.asset("assets/images/logotipo.png",
                  width: 125, height: 125),
              SizedBox(height: 15),
              Text(
                'Aplicativo que permite acompanhar em tempo real a realização de um evento.',
                textAlign: TextAlign.center,
              ),
              Divider(
                color: Colors.black45,
                indent: 15,
                endIndent: 15,
              ),
              SizedBox(height: 15),
              Text(
                'Versão:',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'V1.0.0',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                'Desenvolvido por:',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'GDW SOLUÇÕES',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                'Contacto:',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'geral@gdwsolucoes.co.ao',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
