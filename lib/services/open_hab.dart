import 'package:http/http.dart' as http;

class OpenHabService {


  // Your IP, localhost might not work
  final _url = "http://<IP>:8080/rest/items";


  //Thing name and a message are required, for this example i'm using a switch, so only ON or OFF will work
  Future sendDataToItem(String thing,String message) async {

    final String url = "$_url/$thing";

    http.post(url,
        headers: {"Content-Type" : "text/plain", "Accept" : "application/json" },
        body: message
    );


  }


}