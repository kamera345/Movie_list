import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_list/user_data.dart';

import 'movie_poster_edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? name;
  String? about;
  Uint8List? _image;

  // void Insert() {
  //   //box1.add(Person(name: name, age: age, friends: friends));
  // }

  // Future getImage() async {`
  //   final value = await ImagePicker().pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     image = value;
  //     print(image!.path);
  //   });
  // }

  // In this init state we are reading the data from the local database to display in our app
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var box = Hive.box('MyData');
    name = box.get('name');
    about = box.get('about');
    _image = box.get('image');
    // print(_image);

    setState(() {});
  }

  final FirebaseAuth _firebase = FirebaseAuth.instance;

  final List<Widget> _content = [
    BottomSheet(
        name1: 'Your Name', name2: 'About Yourself', title: 'Edit Profile'),
    BottomSheetAddNew(
        movieName: 'Movie Name',
        directorName: 'Director Name',
        title: 'Add Movie'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2) {
        _firebase.signOut();
        Navigator.pop(context);
      } else {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => _content[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: SideBarDrawer(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black45,
            // image: DecorationImage(
            //   image: AssetImage('assets/back.jpg'),
            //   fit: BoxFit.cover,
            // ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 30.0, bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          name == null ? 'Your Name' : name!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          about == null
                              ? 'About' + ' ' + '!'
                              : about! + ' ' + '!',
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        // image: DecorationImage(
                        //   image: MemoryImage(_image!),
                        //   fit: BoxFit.cover,
                        // ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Your Watch List'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 30.0),
                child: Divider(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<Person>('person').listenable(),
                  builder: (context, Box<Person> box2, _) {
                    List<int> keys = box2.keys.cast<int>().toList();
                    return ListView.builder(
                      itemCount: box2.length,
                      itemBuilder: (context, index) {
                        final int key = keys[index];
                        final Person per = box2.getAt(key)!;
                        return Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0, right: 20, bottom: 10.0),
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  height: 400.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: MemoryImage(per.file),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 20.0, right: 40.0),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          CircleAvatar(
                                            child: IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                var bb =
                                                    Hive.box<Person>('person');
                                                bb.deleteAt(index);
                                                print(index);
                                              },
                                            ),
                                            backgroundColor: Colors.white,
                                          ),
                                          SizedBox(height: 20.0),
                                          CircleAvatar(
                                            child: IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (conext) =>
                                                      BottomSheete(
                                                    movieName: 'MovieName',
                                                    directorName:
                                                        'DirectorName',
                                                    title: 'Edit Poster',
                                                    index: index,
                                                  ),
                                                );
                                              },
                                            ),
                                            backgroundColor: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 30.0),
                                    child: Container(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40.0),
                                            child: Text(
                                              per.movieName,
                                              style: TextStyle(
                                                fontSize: 40.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 40.0,
                                                right: 40.0,
                                                bottom: 30.0),
                                            child: Text(
                                              '${per.directorName} !',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black12,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

// This is the bottom sheet for editing the user profile
//
//
class BottomSheet extends StatefulWidget {
  const BottomSheet(
      {@required this.name1, @required this.name2, @required this.title});

  final name1;
  final name2;
  final title;

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  String username = '';
  String userabout = '';
  File? _image;
  // Uint8List? binaryArray;

  Box<Person>? box;

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
  void initState() {
    // TODO: implement initState
    super.initState();
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
                    username = value;
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
                    hintText: widget.name1,
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
                    userabout = value;
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
                    hintText: widget.name2,
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
              Text('Please Restart The App after update'),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  var box1 = Hive.box('MyData');
                  box1.put('name', username);
                  box1.put('About', userabout);
                  box1.put('image', _image!.readAsBytesSync());
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

// This is the bottom sheet for adding the new movies to the ClipboardStatus
//
//
//
class BottomSheetAddNew extends StatefulWidget {
  BottomSheetAddNew(
      {@required this.movieName,
      @required this.directorName,
      @required this.title});
  final movieName;
  final directorName;
  final title;

  @override
  _BottomSheetAddNewState createState() => _BottomSheetAddNewState();
}

class _BottomSheetAddNewState extends State<BottomSheetAddNew> {
  String username = '';
  String userabout = '';
  File? _image;

  Future getImageFile() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('Imge not Selected');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                    username = value;
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
                    userabout = value;
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
                      movieName: username,
                      directorName: userabout,
                      file: _image!.readAsBytesSync());
                  box2.add(per);
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
