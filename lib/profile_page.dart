import 'package:flutter/material.dart';
import 'home_page.dart';
import 'calendar_page.dart';
import 'tools_page.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String email;

  ProfilePage({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF757121)),
        title: Text(
          'Terra Tales',
          style: TextStyle(
            color: Color(0xFF757121),
            fontSize: 24,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'MY PROFILE',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Color(0xFF757121),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 20.0),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('images/profile.png'), // Update with your profile image
              ),
              SizedBox(height: 20.0),
              Text(
                name,
                style: TextStyle(
                  fontSize: 24.0,
                  color: Color(0xFF757121),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                'Farmer',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Color(0xFF757121),
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                email,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Color(0xFF757121),
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                'Email Address:',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Color(0xFF757121),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 3,
        selectedItemColor: Color(0xFF757121),
        unselectedItemColor: Color(0xFF757121),
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(name: name, email: email)),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarPage(name: name, email: email)),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ToolsPage(name: name, email: email)),
              );
              break;
            case 3:
              // Current page
              break;
          }
        },
      ),
    );
  }
}