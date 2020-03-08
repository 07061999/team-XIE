import 'package:receipt/mlkit/text_home.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:mlkit/mlkit.dart';

class MLDetail extends StatefulWidget {
  final File _file;

  MLDetail(this._file);

  @override
  State<StatefulWidget> createState() {
    return _MLDetailState();
  }
}

class _MLDetailState extends State<MLDetail> {
  FirebaseVisionTextDetector textDetector = FirebaseVisionTextDetector.instance;
  List<VisionText> _currentTextLabels = <VisionText>[];

  Stream sub;
  StreamSubscription<dynamic> subscription;

  @override
  void initState() {
    super.initState();
    sub = new Stream.empty();
    subscription = sub.listen((_) => _getImageSize)..onDone(analyzeLabels);
  }

  void analyzeLabels() async {
    try {
      var currentLabels;
      currentLabels = await textDetector.detectFromPath(widget._file.path);
      if (this.mounted) {
        setState(() {
          _currentTextLabels = currentLabels;
        });
      }

    } catch (e) {
      print("MyEx: " + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Text Detection"),
        ),
        body: Column(
          children: <Widget>[
            buildImage(context),
            buildTextList(_currentTextLabels)
//            RaisedButton(onPressed: null, )
          ],
        ));
  }

  Widget buildImage(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Center(
            child: widget._file == null
                ? Text('No Image')
                : FutureBuilder<Size>(
                    future: _getImageSize(
                        Image.file(widget._file, fit: BoxFit.fitWidth)),
                    builder:
                        (BuildContext context, AsyncSnapshot<Size> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                            foregroundDecoration:TextDetectDecoration(
                                    _currentTextLabels, snapshot.data),
                            child:
                                Image.file(widget._file, fit: BoxFit.fitWidth));
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
          )),
    );
  }
  Widget buildTextList(List<VisionText> texts) {
    if (texts.length == 0) {
      return Expanded(
          flex: 1,
          child: Center(
            child: Text('No text detected',
                style: Theme.of(context).textTheme.subhead),
          ));
    }
    return Expanded(
      flex: 1,
      child: Container(
        child: ListView.builder(
            padding: const EdgeInsets.all(1.0),
            itemCount: texts.length,
            itemBuilder: (context, i) {
              return _buildTextRow(texts[i].text);
            }),

      ),
    );
  }

  Widget _buildTextRow(text) {
    return ListTile(
      title: Text(
        "$text",
      ),
      dense: true,
    );
  }

  Future<Size> _getImageSize(Image image) {
    Completer<Size> completer = Completer<Size>();
    image.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo info, bool _) => completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble()))));
    return completer.future;
  }
}
class TextDetectDecoration extends Decoration {
  final Size _originalImageSize;
  final List<VisionText> _texts;
  TextDetectDecoration(List<VisionText> texts, Size originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _TextDetectPainter(_texts, _originalImageSize);
  }
}

class _TextDetectPainter extends BoxPainter {
  final List<VisionText> _texts;
  final Size _originalImageSize;
  _TextDetectPainter(texts, originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..strokeWidth = 2.0
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    final _heightRatio = _originalImageSize.height / configuration.size.height;
    final _widthRatio = _originalImageSize.width / configuration.size.width;
    for (var text in _texts) {
      final _rect = Rect.fromLTRB(
          offset.dx + text.rect.left / _widthRatio,
          offset.dy + text.rect.top / _heightRatio,
          offset.dx + text.rect.right / _widthRatio,
          offset.dy + text.rect.bottom / _heightRatio);
      canvas.drawRect(_rect, paint);
    }
    canvas.restore();
  }
}

// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:mlkit/mlkit.dart';

// class MLDetail extends StatefulWidget {
//   final File _file;

//   MLDetail(this._file);

//   @override
//   _MLDetailState createState() => _MLDetailState();
// }

// class _MLDetailState extends State<MLDetail> {

//   FirebaseVisionTextDetector textDetector = FirebaseVisionTextDetector.instance;
//   List<VisionText> _currentTextLabels = <VisionText>[];

//   Stream sub;
//   StreamSubscription<dynamic> subscription;

//   @override
//   void initState() {
//     super.initState();
//     sub = new Stream.empty();
//     subscription = sub.listen((_) => _getImageSize)..onDone(analyzeLabels);
//   }

//   void analyzeLabels() async {
//     try {
//       var currentLabels;
//       currentLabels = await textDetector.detectFromPath(widget._file.path);
//       if (this.mounted) {
//         setState(() {
//           _currentTextLabels = currentLabels;
//         });
//       }

//     } catch (e) {
//       print("MyEx: " + e.toString());
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     subscription?.cancel();
//   }

//   Widget buildImage(BuildContext context) {
//     return Expanded(
//       flex: 2,
//       child: Container(
//           decoration: BoxDecoration(color: Colors.black),
//           child: Center(
//             child: widget._file == null
//                 ? Text('No Image')
//                 : FutureBuilder<Size>(
//                     future: _getImageSize(
//                         Image.file(widget._file, fit: BoxFit.fitWidth)),
//                     builder:
//                         (BuildContext context, AsyncSnapshot<Size> snapshot) {
//                       if (snapshot.hasData) {
//                         return Container(
//                             foregroundDecoration:TextDetectDecoration(
//                                     _currentTextLabels, snapshot.data),
//                             child:
//                                 Image.file(widget._file, fit: BoxFit.fitWidth));
//                       } else {
//                         return CircularProgressIndicator();
//                       }
//                     },
//                   ),
//           )),
//     );
//   }

//   Widget buildTextList(List<VisionText> texts) {
//     if (texts.length == 0) {
//       return Expanded(
//           flex: 1,
//           child: Center(
//             child: Text('No text detected',
//                 style: Theme.of(context).textTheme.subhead),
//           ));
//     }
//     return Expanded(
//       flex: 1,
//       child: Container(
//         child: ListView.builder(
//             padding: const EdgeInsets.all(1.0),
//             itemCount: texts.length,
//             itemBuilder: (context, i) {
//               return _buildTextRow(texts[i].text);
//             }),

//       ),
//     );
//   }

//   Widget _buildTextRow(text) {
//     return ListTile(
//       title: Text(
//         "$text",
//       ),
//       dense: true,
//     );
//   }

//   Future<Size> _getImageSize(Image image) {
//     Completer<Size> completer = Completer<Size>();
//     image.image.resolve(ImageConfiguration()).addListener(
//         ImageStreamListener((ImageInfo info, bool _) => completer.complete(
//             Size(info.image.width.toDouble(), info.image.height.toDouble()))));
//     return completer.future;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return null;
//   }
// }
// class TextDetectDecoration extends Decoration {
//   final Size _originalImageSize;
//   final List<VisionText> _texts;
//   TextDetectDecoration(List<VisionText> texts, Size originalImageSize)
//       : _texts = texts,
//         _originalImageSize = originalImageSize;

//   @override
//   BoxPainter createBoxPainter([VoidCallback onChanged]) {
//     return _TextDetectPainter(_texts, _originalImageSize);
//   }
// }

// class _TextDetectPainter extends BoxPainter {
//   final List<VisionText> _texts;
//   final Size _originalImageSize;
//   _TextDetectPainter(texts, originalImageSize)
//       : _texts = texts,
//         _originalImageSize = originalImageSize;

//   @override
//   void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
//     final paint = Paint()
//       ..strokeWidth = 2.0
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke;

//     final _heightRatio = _originalImageSize.height / configuration.size.height;
//     final _widthRatio = _originalImageSize.width / configuration.size.width;
//     for (var text in _texts) {
//       final _rect = Rect.fromLTRB(
//           offset.dx + text.rect.left / _widthRatio,
//           offset.dy + text.rect.top / _heightRatio,
//           offset.dx + text.rect.right / _widthRatio,
//           offset.dy + text.rect.bottom / _heightRatio);
//       canvas.drawRect(_rect, paint);
//     }
//     canvas.restore();
//   }

//   List<Widget> containers = [
//     Container(
//       // child: buildImage(context),
//       color: Colors.deepOrange,
//     ),
//     Container(
//       color:Colors.blue
//     )
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//           child: Scaffold(
//         appBar: AppBar(
//           title: Text('Text Detection'.toUpperCase()),
//           bottom: TabBar(
//             tabs: <Widget>[
//               Tab(
//                 text:"Image"
//               ),
//               Tab(
//                 text:"Extracted Image"
//               )
//             ]
//           ),
//         ),
//         body: TabBarView(children: containers),
//       ),
//     );
//   }
// }