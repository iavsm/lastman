import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'notifications.dart';


Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {


  print("Last Man standing $message");
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();




  void notiCallBack(context, Map<String, dynamic> message) {
    //Map<String, dynamic> notifyMessage= jsonDecode(message['notification']['body']);
    // print("inside notiCallBack $message");
    print(navigatorKey.currentState.overlay.context);
    showDialog(
      context: navigatorKey.currentContext,
      barrierDismissible: false,
      builder: (x) => AlertDialog(
        content: ListTile(
          title: Text(message['notification']['title'],
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          //subtitle: Text(notifyMessage['message']),
          subtitle: Text(message['notification']['body']),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () =>
                Navigator.of(navigatorKey.currentState.overlay.context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    FirebaseNotifications _fn = new FirebaseNotifications(notiCallBack);



    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        notiCallBack(context, message);
        // _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //  _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        //_navigateToItemDetail(message);
      },onBackgroundMessage: myBackgroundMessageHandler
    );
    return MaterialApp(
      title: 'Last Man Standing',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: navigatorKey,
      body: WebView(
        initialUrl: "https://app.lastmanstandingcompetitie.nl",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
