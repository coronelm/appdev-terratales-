import 'package:flutter/material.dart';

class ToolsOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Terra Tales',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            color: Color(0xFF757121),
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Rake'),
            subtitle: Text('Good to Use'),
          ),
          ListTile(
            title: Text('Shovel'),
            subtitle: Text('For Repair'),
          ),
          // Add more tools here
        ],
      ),
    );
  }
}
