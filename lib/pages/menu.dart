import 'package:app/pages/login_page.dart';
import 'package:app/pages/profile.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => MenuState();
}

class MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Menu'),
        ),
        body: Column(children: [
          GestureDetector(
            onTap: () {
              LoginPageState.data.setBool('login_state', false);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
            child: Container(
                width: double.maxFinite,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade200,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profile',
                      style: TextStyle(fontSize: 25),
                    ),
                    Icon(Icons.arrow_forward_rounded)
                  ],
                )),
          )
        ]));
  }
}
