import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;

class Grafico extends StatefulWidget {
  @override
  _GraficoState createState() => _GraficoState();
}

class Estatistica {
  String estado;
  double valor;
  Color cor;

  Estatistica(this.estado, this.valor, this.cor);
}

List<charts.Series<Estatistica, String>> _seriesPieData;
_pegarDados() {
  var pieData = [
    new Estatistica("Ausente", 30, Colors.red),
    new Estatistica("Presente", 10, Colors.green),
  ];

  _seriesPieData.add(
    charts.Series(
      data: pieData,
      domainFn: (Estatistica estatistica, _) => estatistica.estado,
      measureFn: (Estatistica estatistica, _) => estatistica.valor,
      colorFn: (Estatistica estatistica, _) =>
          charts.ColorUtil.fromDartColor(estatistica.cor),
      id: 'Estatistica de Convidados',
      labelAccessorFn: (Estatistica estatistica, _) => '${estatistica.valor}',
    ),
  );
}

class _GraficoState extends State<Grafico> {
  @override
  void initState() {
    super.initState();
    _seriesPieData = List<charts.Series<Estatistica, String>>();
    _pegarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        title:
            Image.asset("assets/images/logotopo.png", width: 150, height: 50),
        //title: Text("GESTEVENTO",textAlign: TextAlign.end,style: TextStyle(color: Colors.yellow,fontSize: 20,fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Text(
              'Estatistica de Convidados',
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: charts.PieChart(_seriesPieData,
                  animate: true,
                  animationDuration: Duration(seconds: 1),
                  behaviors: [
                    new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.startDrawArea,
                        horizontalFirst: false,
                        desiredMaxColumns: 1,
                        cellPadding: new EdgeInsets.only(
                            top: 15.0, right: 10.0, bottom: 4.0),
                        entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 11,
                        ))
                  ],
                  defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 100,
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.auto)
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}
