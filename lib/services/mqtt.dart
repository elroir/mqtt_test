import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/material.dart';

enum ServerStatus {
  Online,
  Offline
}

class MqttService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Offline;

  get serverStatus => this._serverStatus;

  MqttServerClient client;

  Future<MqttServerClient> connect() async {
    // Port is usually 1883 but it can change
    client =
    MqttServerClient.withPort('<Server>', 'flutter_client',1883,maxConnectionAttempts: 1);
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    try {
      //If you don't have username and password, leave it empty
      await client.connect('<USERNAME>', '<PASSWORD>');
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }
    return client;
  }

  // Call this function tu publish a message
  Future<void> publish(String topic,String message) async {
    if (client != null){
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topic, MqttQos.atLeastOnce,builder.payload);
    }
  }


  // connection succeeded
  void onConnected() {
    print('connected');
    client.connectionStatus.state = MqttConnectionState.connected;
    this._serverStatus = ServerStatus.Online;
    notifyListeners();
  }

// unconnected
  void onDisconnected() {
    client.connectionStatus.state = MqttConnectionState.disconnected;
    this._serverStatus = ServerStatus.Offline;
    notifyListeners();

  }

// subscribe to topic succeeded
  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

// subscribe to topic failed
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

// unsubscribe succeeded
  void onUnsubscribed(String topic) {
    print('Unsubscribed topic: $topic');
  }


}