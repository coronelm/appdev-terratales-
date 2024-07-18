import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'calendar_page.dart';

class ToolsPage extends StatelessWidget {
  final String name;
  final String email;

  ToolsPage({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tools & Equipment'),
        backgroundColor: Color(0xFF757121),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ToolItem(
            image: AssetImage('images/Rake.jpg'),
            toolName: 'Rake',
          ),
          SizedBox(height: 16),
          ToolItem(
            image: AssetImage('images/Shovel.jpg'),
            toolName: 'Shovel',
          ),
          SizedBox(height: 16),
          ToolItem(
            image: AssetImage('images/HedgeShear.jpg'),
            toolName: 'Hedge Shear',
          ),
          SizedBox(height: 16),
          ToolItem(
            image: AssetImage('images/Trowel.jpg'),
            toolName: 'Trowel',
          ),
          SizedBox(height: 16),
          ToolItem(
            image: AssetImage('images/Axe.jpg'),
            toolName: 'Axe',
          ),
          SizedBox(height: 16),
          ToolItem(
            image: AssetImage('images/Dibber.jpg'),
            toolName: 'Dibber',
          ),
          SizedBox(height: 16),
          ToolItem(
            image: AssetImage('images/GardenFork.jpg'),
            toolName: 'Garden Fork',
          ),
          SizedBox(height: 16),
          ToolItem(
            image: AssetImage('images/GardenGloves.jpg'),
            toolName: 'Garden Gloves',
          ),
          SizedBox(height: 16),
          ToolItem(
            image: AssetImage('images/GardenHoe.jpg'),
            toolName: 'Garden Hoe',
          ),
          SizedBox(height: 16),
          ToolItem(
            image: AssetImage('images/GardeningCan.jpg'),
            toolName: 'Gardening Can',
          ),
          SizedBox(height: 16),
          ToolItem(
            image: AssetImage('images/Loppers.jpg'),
            toolName: 'Loppers',
          ),
          SizedBox(height: 16),
          ToolItem(
            image: AssetImage('images/Mattock.jpg'),
            toolName: 'Mattock',
          ),
          SizedBox(height: 16),
          ToolItem(
            image: AssetImage('images/Sickle.jpg'),
            toolName: 'Sickle',
          ),
          SizedBox(height: 16),
          ToolItem(
            image: AssetImage('images/Weeder.jpg'),
            toolName: 'Weeder',
          ),
          SizedBox(height: 16),
          ToolItem(
            image: AssetImage('images/WheelBarrow.jpg'),
            toolName: 'Wheel Barrow',
          ),
        ],
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
        currentIndex: 2,
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
              // Current page
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(name: name, email: email)),
              );
              break;
          }
        },
      ),
    );
  }
}

class ToolItem extends StatefulWidget {
  final ImageProvider image;
  final String toolName;

  ToolItem({required this.image, required this.toolName});

  @override
  _ToolItemState createState() => _ToolItemState();
}

class _ToolItemState extends State<ToolItem> {
  String _selectedValue = 'Good to Use';

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Color(0xFFF7F4E9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image(
              image: widget.image,
              width: 50,
              height: 50,
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.toolName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: _selectedValue,
                  items: <String>['Good to Use', 'For Repair', 'Needs Replacement']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedValue = newValue!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}