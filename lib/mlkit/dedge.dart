// import 'dart:io';

// import 'package:edge_detection/edge_detection.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:receipt/mlkit/text_detail.dart';

// class DEdge extends StatefulWidget {
//   @override
//   _DEdgeState createState() => _DEdgeState();
// }

// class _DEdgeState extends State<DEdge> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   File _file;
//   String _imagePath = 'Unknown';

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String imagePath;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       imagePath = await EdgeDetection.detectEdge;
//     } on PlatformException {
//       imagePath = 'Failed to get cropped image path.';
//     }

//     if (!mounted) return;

//     setState(() {
//       _imagePath = imagePath;
//     });

//     try {
//       final file = await Image.asset(_imagePath);
//       if (file == null) {
//         throw Exception('File is not available');
//       }

//       // Navigator.push(
//       //   context,
//       //   new MaterialPageRoute(
//       //       builder: (context) => MLDetail(_imagePath)),
//       // );
//     } catch (e) {
//     //  scaffold.showSnackBar(SnackBar(
//     //    content: Text(e.toString()),
//     //  ));
//     print(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new Scaffold(
//         key: _scaffoldKey,
//         appBar: new AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: new Center(
//           child:  Column(
//             children: <Widget>[
//               new Text('image saved at $_imagePath\n'),
//               RaisedButton(onPressed: (){

//                 Navigator.pop(context);
//               }, child: Text("Extract Data"),)

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
