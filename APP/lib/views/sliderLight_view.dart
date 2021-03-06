import 'package:flutter/material.dart';
import 'package:main_app/widgets/sideMenu_widget.dart';

import 'package:main_app/widgets/desconected_widget.dart';
import 'package:provider/provider.dart';
import 'package:main_app/controllers/connection_controller.dart';
class SliderLight extends StatefulWidget {
  final String title;
  final int id;
  SliderLight(this.title,this.id);
  @override
  _SliderLightState createState() => _SliderLightState(title,id);
}
class _SliderLightState extends State<SliderLight> {
  String title;
  int id;
  _SliderLightState(this.title,this.id);

  double _sliderState = 0;
  double _lightState = 0;
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Provider.of<ConnectionController>(context).loadData();
    if(Provider.of<ConnectionController>(context).loaded && !Provider.of<ConnectionController>(context).tryedConnection){
      Provider.of<ConnectionController>(context).startConnection();
    }
    String connection = Provider.of<ConnectionController>(context).MQTTconnection;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        drawer: MenuDrawer(),
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          actions: connection != 'disconnected'  ? null :[
            Desconected(),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.lightbulb,
              color: Colors.grey[400],
              size: 30.0,
            ),
            Container(
              height: 400,
              child: RotatedBox(
                quarterTurns: -1,
                child: Slider(
                  value: _sliderState,
                  min: 0,
                  max: 1023,
                  onChanged: (value) {
                    setState(() {
                      _sliderState = value;
                    });
                    if((_sliderState - _lightState).abs() >= 10) {
                      _lightState = _sliderState;
                      if(connection == 'connected'){
                        Provider.of<ConnectionController>(context, listen: false).publishMessage("$id|$_lightState");
                      }
                    }
                    if(_sliderState < 10){
                      if(connection == 'connected'){
                        Provider.of<ConnectionController>(context, listen: false).publishMessage("$id|0.0");
                      }
                    }
                  },
                  activeColor: Colors.grey,
                  inactiveColor: Colors.grey[700],
                ),
              ),
            ),
            Icon(
              Icons.lightbulb_outline,
              color: Colors.grey[400],
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}