import 'package:app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.lightBlue,
        ),
        body: Center(
          child: Column(children: [
            SizedBox(height: 50),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assests/avatar.jpg'),
            ),
            SizedBox(height: 20),
            Text('Ayush Pal', style: TextStyle(fontSize: 25)),
            ElevatedButton(
                onPressed: () async {
                  await LoginPageState().logout().whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  });
                },
                child: Text('Logout'))
          ]),
        ));
  }
}
