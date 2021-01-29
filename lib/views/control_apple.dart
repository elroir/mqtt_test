import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mqtt_test/helpers/client_handler.dart';
import 'package:mqtt_test/services/mqtt.dart';
import 'package:mqtt_test/services/open_hab.dart';
import 'package:provider/provider.dart';



class ControlAppleView extends StatelessWidget {

  final openHab = new OpenHabService();

  @override
  Widget build(BuildContext context) {
    final MqttService mqtt = Provider.of<MqttService>(context);
    return Scaffold(
      body: Center(
        child: Container(
            child: RawMaterialButton(
              //Same as control but for an apple tv
              onPressed: () async {
                if (ClientHandler.instance.currentClient == 0){
                  if(mqtt.serverStatus == ServerStatus.Online)
                    mqtt.publish('control/apple_tv','77E1C080');
                  else{
                    await mqtt.connect();
                    mqtt.publish('control/apple_tv','77E1C080');
                  }
                }else
                  openHab.sendDataToItem('Control_power', 'OFF');

              },
              elevation: 2.0,
              fillColor: Theme.of(context).primaryColor,
              child: Icon( FontAwesome.power_off,size: 120.0, color: Colors.white70, ),
              padding: EdgeInsets.all(20.0),
              shape: CircleBorder(),
            )
        ),

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
