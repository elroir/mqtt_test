import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mqtt_test/helpers/client_handler.dart';
import 'package:mqtt_test/services/mqtt.dart';
import 'package:mqtt_test/services/open_hab.dart';
import 'package:provider/provider.dart';

class ControlView extends StatefulWidget {

  @override
  _ControlViewState createState() => _ControlViewState();
}

class _ControlViewState extends State<ControlView> {
  final openHab = new OpenHabService();

  @override
  Widget build(BuildContext context) {
    final MqttService mqtt = Provider.of<MqttService>(context);
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              child: RawMaterialButton(
                //For this example, i'm sending Hex code to a topic called control/lg
                onPressed: () async {
                  if (ClientHandler.instance.currentClient==0){
                    if(mqtt.serverStatus == ServerStatus.Online)
                      mqtt.publish('control/lg','20DF40BF');
                    else{
                      await mqtt.connect();
                      mqtt.publish('control/lg','20DF40BF');
                    }
                  }else{
                    //If you are using OpenHAB make sure to use a switch for this example
                    openHab.sendDataToItem('Control_LG', 'OFF');
                  }
                },
                elevation: 2.0,
                fillColor: Theme.of(context).primaryColor,
                child: Icon( FontAwesome.power_off,size: 120.0, color: Colors.white70, ),
                padding: EdgeInsets.all(20.0),
                shape: CircleBorder(),
              )
            ),
          ),
        ],
      ),
      floatingActionButton:(ClientHandler.instance.currentClient==0) ? FloatingActionButton.extended(
        label:(mqtt.serverStatus == ServerStatus.Offline) ? Text('Disconnected') : Text('Connected'),
        icon: (mqtt.serverStatus == ServerStatus.Offline) ? Icon(Icons.offline_bolt) : Icon(Icons.check_circle),
        backgroundColor: (mqtt.serverStatus == ServerStatus.Offline) ? Colors.red : Colors.blue,
        onPressed: () {}
      ) : null,
    );
  }
}
