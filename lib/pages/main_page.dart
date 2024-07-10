import 'package:app/pages/tabs/home.dart';
import 'package:app/pages/menu.dart';
import 'package:app/pages/storage/files.dart';
import 'package:app/pages/tabs/document.dart';
import 'package:app/pages/tabs/media.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  Reference storage = FirebaseStorage.instance.ref();
  final pages = [
    const Home(name: '', image: '',),
    const Document(),
    const Media(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Milton Cloud Storage Application'),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
              onPressed: () {
                print('Hello');

                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Menu()));
              },
              icon: Icon(Icons.menu))
        ],
      ),
      // body: Column(children: [
      //   SizedBox(height: 70),
      //   Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      //     GestureDetector(
      //       onTap: () {
      //         Navigator.push(
      //             context, MaterialPageRoute(builder: (context) => Files()));
      //       },
      //       child: Container(
      //         padding: EdgeInsets.all(15),
      //         decoration: BoxDecoration(
      //             color: Colors.deepPurple.shade50,
      //             borderRadius: BorderRadius.circular(25)),
      //         child: Image.asset('assests/files.png', width: 100, height: 100),
      //       ),
      //     ),
      //     Container(
      //       margin: EdgeInsets.only(left: 10),
      //       padding: EdgeInsets.all(15),
      //       decoration: BoxDecoration(
      //           color: Colors.deepPurple.shade50,
      //           borderRadius: BorderRadius.circular(25)),
      //       child: Image.asset('assests/files.png', width: 100, height: 100),
      //     )
      //   ])
      // ]),
      body: pages.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor:
            selectedIndex == 0 ? Colors.blueGrey: Colors.deepPurple,
          backgroundColor: Colors.blue.shade100,
        items: [
          BottomNavigationBarItem(
              label: "Home",
              icon: IconButton(
                icon: Icon(Icons.home_filled),
                onPressed: () {
                  selectedIndex = 0;
                  print(selectedIndex);
                  setState(() {

                  });
                },
              )),
          BottomNavigationBarItem(
              label: "Documents",
              icon: IconButton(
                icon: Icon(
                  Icons.file_copy_sharp,
                  color: Colors.blueGrey,
                ),
                onPressed: () {
                  selectedIndex = 1;
                  print(selectedIndex);
                  setState(() {

                  });
                },
              )),
          BottomNavigationBarItem(
              label: "Photos & Videos",
              icon: IconButton(
                icon: Icon(
                  Icons.perm_media_rounded,
                  color: Colors.blueGrey,
                ),
                onPressed: () {
                  selectedIndex = 2;
                  print(selectedIndex);
                  setState(() {

                  });
                },
              ))
        ],
      ),
    );
  }
}
