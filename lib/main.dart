import 'package:flutter/material.dart';
import 'forms_page.dart';

void main() {
  runApp(TerraTalesApp());
}

class TerraTalesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Terra Tales',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/landing.png'), // Your image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Terra',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 100.0,
                          fontWeight: FontWeight.w200,
                          color: Color(0xFFCCCF27),
                          fontFamily: 'BrightRetro',
                          height: 0.5,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'Tales',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 100.0,
                          fontWeight: FontWeight.w200,
                          color: Color(0xFF697719),
                          fontFamily: 'BrightRetro',
                          height: 0.5,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        ' An app for farmers to keep track of their crops, tools,\n and important dates. '
                        'It works anywhere, even without\n internet, helping farmers stay organized and improve\n their farming.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Color(0xFF2F4F4F),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Center(
                  child: SizedBox(
                    width: 225.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FormsPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 239, 247, 239),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        'GET STARTED',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 17, 98, 12),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
