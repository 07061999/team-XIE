 import 'package:receipt/mlkit/text_home.dart';

 import 'package:flutter/material.dart';
 import 'package:firebase_analytics/firebase_analytics.dart';
 import 'package:firebase_analytics/observer.dart';

 void main() => runApp(new MyApp());

 class MyApp extends StatelessWidget {
   static FirebaseAnalytics analytics = new FirebaseAnalytics();
   static FirebaseAnalyticsObserver observer =
       new FirebaseAnalyticsObserver(analytics: analytics);

   // This widget is the root of your application.
   @override
   Widget build(BuildContext context) {
     return new MaterialApp(
       debugShowCheckedModeBanner: false,
       title: 'Receipt-Detection',
       theme: new ThemeData(
         primarySwatch: Colors.deepPurple,
       ),
       navigatorObservers: <NavigatorObserver>[observer],
       home: new MLHome(),
     );
   }
 }
//import 'package:flutter/material.dart';
//import 'dart:async';
//
//import 'package:flutter/services.dart';
//import 'package:edge_detection/edge_detection.dart';
//import 'package:receipt/mlkit/text_home.dart';
//
//void main() => runApp(new MyApp());
//
//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => new _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  String _imagePath = 'Unknown';
//
//  @override
//  void initState() {
//    super.initState();
//    initPlatformState();
//  }
//
//  // Platform messages are asynchronous, so we initialize in an async method.
//  Future<void> initPlatformState() async {
//    String imagePath;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      imagePath = await EdgeDetection.detectEdge;
//    } on PlatformException {
//      imagePath = 'Failed to get cropped image path.';
//    }
//
//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) return;
//
//    setState(() {
//      _imagePath = imagePath;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      home: new Scaffold(
//        appBar: new AppBar(
//          title: const Text('Plugin example app'),
//        ),
//        body: new Center(
//          child: Column(
//            children: <Widget>[
//              _imagePath != null ? Navigator.push(context, new MaterialPageRoute(builder: (context) => MLHome())) : new Text('Cropped image path: $_imagePath\n'),
//              RaisedButton(onPressed: () => Navigator.pop(context), child: Text("Extract text")),
//              RaisedButton(onPressed: () => Navigator.pop(context), child: Text("Go Back"))
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
