import 'package:flutter/material.dart';
import 'home_page.dart';
// ignore: unused_import
import 'calendar_page.dart';
import 'tools_page.dart';
import 'landing_page.dart';
import 'calendar_notes_page.dart';  // Add this import

class AppDrawer extends StatelessWidget {
  final String name;
  final String email;
  final Map<DateTime, List<Map<String, String>>> notes;

  AppDrawer({required this.name, required this.email, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(name[0]),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.note, color: Color(0xFF757121)),
            title: const Text('All Notes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(name: name, email: email)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Color(0xFF757121)),
            title: const Text('Calendar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarNotesPage(notes: notes)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.build, color: Color(0xFF757121)),
            title: const Text('Tools & Equipment'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ToolsPage(name: name, email: email)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Color(0xFF757121)),
            title: const Text('Exit'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
