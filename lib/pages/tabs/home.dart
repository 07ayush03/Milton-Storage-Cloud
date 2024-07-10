import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required String name, required String image})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Color(0xFF3F3F3F),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Keep memories',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontStyle: FontStyle.italic)),
              Text('Store your precious moments and manage access ',
                  style: TextStyle(fontSize: 15, color: Colors.white)),
              SizedBox(height: 10),
              Image.asset('assests/home_background.jpg',
                  width: double.maxFinite),
            ],
          ),
        ),
        SizedBox(height: 10),

        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Color(0xFF3F3F3F),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('More features coming your way soon...',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontStyle: FontStyle.italic)),
              //Text('Store your precious moments and manage access ',style: TextStyle(fontSize:15,color :Colors.white)),
              SizedBox(height: 10),
              Image.asset('assests/background_image-transformed.jpeg',
                  width: double.maxFinite),
            ],
          ),
        ),

        // SizedBox(height: 70),
        // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        //   GestureDetector(
        //     onTap: () {
        //       // Navigator.push(
        //       //     context, MaterialPageRoute(builder: (context) => Files()));
        //     },
        //
        //
        //
        //     child: Container(
        //       padding: EdgeInsets.all(15),
        //       decoration: BoxDecoration(
        //           color: Colors.deepPurple.shade200,
        //           borderRadius: BorderRadius.circular(25)),
        //       child: Image.asset('assests/files.png', width: 100, height: 100),
        //
        //     ),
        //   ),
        // ])
      ]),
    );
  }
}
