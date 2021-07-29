import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:movie_list/user_data.dart';

class BottomSheete extends StatefulWidget {
  const BottomSheete(
      {this.movieName, this.directorName, this.title, this.index});

  final movieName;
  final directorName;
  final title;
  final index;

  @override
  _BottomSheeteState createState() => _BottomSheeteState();
}

class _BottomSheeteState extends State<BottomSheete> {
  String moviename = '';
  String director = '';
  File? _image;

  Future getImageFile() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
        // binaryArray = _image!.readAsBytesSync();
        // print(binaryArray.runtimeType);
      } else {
        print('Imge not Selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0, left: 40.0, right: 40.0),
                child: TextField(
                  onChanged: (value) {
                    moviename = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    filled: true,
                    fillColor: Colors.black12,
                    prefixIcon: Icon(
                      Icons.account_circle,
                    ),
                    hintText: widget.movieName,
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
                child: TextField(
                  onChanged: (value) {
                    director = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    filled: true,
                    fillColor: Colors.black12,
                    prefixIcon: Icon(
                      Icons.favorite,
                    ),
                    hintText: widget.directorName,
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 80.0, right: 40.0, top: 10.0),
                child: ListTile(
                  leading: Icon(Icons.cloud_upload),
                  title: Text(widget.title),
                  onTap: () {
                    getImageFile();
                  },
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  var box2 = Hive.box<Person>('person');
                  var per = Person(
                      movieName: moviename,
                      directorName: director,
                      file: _image!.readAsBytesSync());
                  box2.putAt(widget.index, per);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
