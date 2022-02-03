import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SampleAppState();
  }
}

class SampleAppState extends State<SampleApp> {
  DateTime alert;
  final editControllerMinutes = TextEditingController();
  final editControllerSeconds = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    alert = DateTime.now().add(Duration(seconds: 70));//arranca en automatico
  }

  void dispose() {
    editControllerMinutes.dispose();
    editControllerSeconds.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Prueba de timer'),
        ),
        body: TimerBuilder.scheduled([alert], builder: (context) {
          // This function will be called once the alert time is reached
          var now = DateTime.now();
          var reached = now.compareTo(alert) >= 0;
          final textStyle = Theme.of(context).textTheme;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 50),
                        child: TextFormField(
                          controller: editControllerMinutes,
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          onChanged: (text) {
                            var _istime = isTime( int.parse(text) );
                            if(_istime)
                              print('bien segundos');
                            else
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text("Formato incorrecto",
                                    textAlign: TextAlign.center, style: TextStyle(fontSize: 14.0, fontWeight:
                                    FontWeight.bold),), duration: Duration(seconds: 1), backgroundColor: Colors.red,)
                              );
                          },
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Minutos',
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 50),
                        child: TextFormField(
                          controller: editControllerSeconds,
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          onChanged: (text) {
                            var _istime = isTime( int.parse(text) );
                            if(_istime)
                              print('bien segundos');
                            else
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text("Formato incorrecto",
                                    textAlign: TextAlign.center, style: TextStyle(fontSize: 14.0, fontWeight:
                                    FontWeight.bold),), duration: Duration(seconds: 1), backgroundColor: Colors.red,)
                              );
                          },
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Segundos',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Icon(
                  reached ? Icons.alarm_on : Icons.alarm,
                  color: reached ? Colors.red : Colors.green,
                  size: 48,
                ),
                !reached
                    ? TimerBuilder.periodic(Duration(seconds: 1),
                    alignment: Duration.zero, builder: (context) {
                      // This function will be called every second until the alert time
                      var now = DateTime.now();
                      var remaining = alert.difference(now);
                      return Text(
                        formatDuration(remaining),

                      );
                    })
                    : Text("Finalizado", ),
                RaisedButton(
                  child: Text("Inicia"),
                  onPressed: () {

                    var _seconds = editControllerSeconds.text;
                    var _minutess = editControllerMinutes.text;
                    print('editControllerSeconds: '+_seconds );
                    print('editControllerMinutes: '+ _minutess );
                    print('editControllerSeconds: '+ editControllerSeconds.text );
                    print('editControllerMinutes: '+ editControllerMinutes.text );
                    if(_seconds.trim()=='')_seconds='-1';
                    if(_minutess.trim()=='')_minutess='-1';
                    if ( isTime( int.parse(_seconds) ) &&  isTime( int.parse(_minutess) ) )
                      setState(() {
                        int segundos = 0;
                        segundos = (int.parse(_minutess) * 60 ) + int.parse(_seconds);
                        print('segundos: '+segundos.toString());
                        alert = DateTime.now().add(Duration(seconds: segundos));
                      });
                    else
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Formato incorrecto, ingrese munutos y segundos",
                            textAlign: TextAlign.center, style: TextStyle(fontSize: 14.0, fontWeight:
                            FontWeight.bold),), duration: Duration(seconds: 1), backgroundColor: Colors.red,)
                      );
                  },
                ),
              ],
            ),
          );
        }),
      ),
      theme: ThemeData(backgroundColor: Colors.white),
    );
  }
}
bool isTime( int time ) {
  print('isTime');
  if ( time.toString().isEmpty ) return false;
  if ( time >= 0 && time<=60)
    return true;
  return false;

}
String formatDuration(Duration d) {
  String f(int n) {
    return n.toString().padLeft(2, '0');
  }

  // We want to round up the remaining time to the nearest second
  d += Duration(microseconds: 999999);
  return "${f(d.inMinutes)}:${f(d.inSeconds % 60)}";
}