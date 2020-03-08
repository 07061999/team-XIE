// import 'package:edge_detection/edge_detection.dart';
//import 'package:receipt/mlkit/detect.dart';
//import 'package:receipt/mlkit/detect.dart';
import 'package:flutter_multi_carousel/carousel.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:receipt/mlkit/dedge.dart';
import 'package:receipt/mlkit/text_detail.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';



import 'package:flutter/services.dart';
import 'package:receipt/widgets/carousel.dart';

const String TEXT_SCANNER = 'TEXT_SCANNER';

class MLHome extends StatefulWidget {
  MLHome({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MLHomeState();
}

class _MLHomeState extends State<MLHome> {
  String _imagePath = 'Unknown';
  static const String CAMERA_SOURCE = 'CAMERA_SOURCE';
  static const String GALLERY_SOURCE = 'GALLERY_SOURCE';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File _file;
  String _selectedScanner = TEXT_SCANNER;
  List img = ['images/1.jpeg', 'images/2.jpeg', 'images/3.jpeg','images/4.jpeg', 'images/5.jpeg'];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          leading: Container(
            child: Image.asset('images/logo1.png', scale: 1.5,),
          ),
          centerTitle: true,
          title: Text('Receipt Detection'.toUpperCase()),
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Center(
              child: Text('Team XIE',style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 20
              ),),
            ),
          ),
          Center(
            child: Container(
              child: Carousel(
                indicatorBackgroundColor: Colors.white,
                  height: 400.0,
                  width: 350,
                  initialPage: 3,
                  allowWrap: false,
                  type: Types.slideSwiper,
                  onCarouselTap: (i) {
                    print("onTap $i");
                  },
                  indicatorType: IndicatorTypes.bubble,
                  indicatorBackgroundOpacity: 0,
                  // arrowColor: Colors.black,
                  axis: Axis.horizontal,
                  showArrow: true,
                  children: List.generate(
                      5,
                      (i) => Center(
                            child:
                                Container(
                                  constraints: BoxConstraints.expand(height: 300.0),
              decoration: BoxDecoration(color: Colors.grey),
              child: Image.asset(
                img[i],
                fit: BoxFit.cover,
              )
                                ),
                          ))),
            ),
          ),
        ],
      ),
       floatingActionButton: SpeedDial(
        backgroundColor: Colors.deepPurple,
        closeManually: false,
        child: Icon(Icons.add),
        overlayColor: Colors.deepPurple,
        overlayOpacity: 0.2,
        curve: Curves.easeIn,
        onOpen: () => print("Opening"),
        onClose: () => print("Closing"),
        children: [
          SpeedDialChild(
            child: Icon(Icons.camera_alt),
            label: "Camera",
            backgroundColor: Colors.white,
            foregroundColor: Colors.deepPurple,
            onTap: () => onPickImageSelected(CAMERA_SOURCE),
            
          ),
          SpeedDialChild(
            child: Icon(Icons.tab),
            label: "Gallery",
            backgroundColor: Colors.white,
            foregroundColor: Colors.deepPurple,
            onTap: () => onPickImageSelected(GALLERY_SOURCE),
            
          )
        ],
      ),  
    );
  }

  Widget buildRowTitle(BuildContext context, String title) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline,
      ),
    ));
  }

  Widget buildSelectImageRowWidget(BuildContext context) {
    String imagePath;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: RaisedButton(
              color: Colors.deepPurple,
              textColor: Colors.white,
              splashColor: Colors.blueGrey,
              onPressed: () {
                onPickImageSelected(CAMERA_SOURCE);
                // Navigator.push(
                // context,
                // MaterialPageRoute(builder: (context) => DEdge()));
                              }
              ,
              child: const Text('Camera'))
              ,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: RaisedButton(
              
              color: Colors.deepPurple,
              textColor: Colors.white,
              splashColor: Colors.blueGrey,
              onPressed: () {
                onPickImageSelected(GALLERY_SOURCE);
              },
              child: const Text('Gallery')),
            )
          ],
        )
        
      ],
      
    );
  }

  Widget buildSelectScannerRowWidget(BuildContext context) {
    return Wrap(
      children: <Widget>[
        RadioListTile<String>(
          title: Text('Text Recognition'),
          groupValue: _selectedScanner,
          value: TEXT_SCANNER,
          onChanged: onScannerSelected,
        ),
      ],
    );
  }

  Widget buildImageRow(BuildContext context, File file) {
    return SizedBox(
        height: 500.0,
        child: Image.file(
          file,
          fit: BoxFit.fitWidth,
        ));
  }

  Widget buildDeleteRow(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: RaisedButton(
            color: Colors.red,
            textColor: Colors.white,
            splashColor: Colors.blueGrey,
            onPressed: () {
              setState(() {
                _file = null;
              });

            },
            child: const Text('Delete Image')),
      ),
    );
  }

  void onScannerSelected(String scanner) {
    setState(() {
      _selectedScanner = scanner;
    });
  }

  void onPickImageSelected(String source) async {
    var imageSource;
    if (source == CAMERA_SOURCE) {
      imageSource = ImageSource.camera;
    } else {
      imageSource = ImageSource.gallery;
    }

    final scaffold = _scaffoldKey.currentState;

    try {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file == null) {
        throw Exception('File is not available');
      }

      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => MLDetail(file)),
      );
    } catch (e) {
      scaffold.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
