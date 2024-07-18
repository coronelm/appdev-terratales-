import 'package:flutter/material.dart';
import 'home_page.dart'; 
import 'profile_page.dart'; 
import 'tools_page.dart'; 
import 'drawer.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final String name;
  final String email;

  CalendarPage({required this.name, required this.email});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Map<String, String>>> _notes = {
    
  };

  List<Map<String, String>> _getNotesForDay(DateTime day) {
    return _notes[day] ?? [];
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _notes.containsKey(day) ? ['Event'] : [];
  }

  void _addNoteForDay(DateTime day, String title, String body) {
    setState(() {
      if (_notes[day] != null) {
        _notes[day]!.add({'title': title, 'body': body});
      } else {
        _notes[day] = [{'title': title, 'body': body}];
      }
    });
  }

  void _editNoteForDay(DateTime day, int index, String title, String body) {
    setState(() {
      if (_notes[day] != null) {
        _notes[day]![index] = {'title': title, 'body': body};
      }
    });
  }

  void _deleteNoteForDay(DateTime day, int index) {
    setState(() {
      if (_notes[day] != null) {
        _notes[day]!.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Terra Tales',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            color: Color(0xFF757121),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await _displayAddNoteSheet(context);
            },
          ),
        ],
      ),
      drawer: AppDrawer(
        name: widget.name,
        email: widget.email,
        notes: _notes,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: _getEventsForDay,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(0xFF757121),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(color: Colors.red[600]),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _getNotesForDay(_selectedDay ?? _focusedDay).length,
              itemBuilder: (context, index) {
                final note = _getNotesForDay(_selectedDay ?? _focusedDay)[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(note['title']!),
                    subtitle: Text(note['body']!),
                    onTap: () async {
                      await _displayAddNoteSheet(context, note: note, index: index);
                    },
                    onLongPress: () {
                      _deleteNoteForDay(_selectedDay ?? _focusedDay, index);
                    },
                  ),
                );
              },
            ),
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
        currentIndex: 1,
        selectedItemColor: Color(0xFF757121),
        unselectedItemColor: Color(0xFF757121),
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(name: widget.name, email: widget.email)),
              );
              break;
            case 1:
              // Current Page
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ToolsPage(name: widget.name, email: widget.email)),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(name: widget.name, email: widget.email)),
              );
              break;
          }
        },
      ),
    );
  }

  Future<void> _displayAddNoteSheet(BuildContext context, {Map<String, String>? note, int? index}) async {
    final titleController = TextEditingController(text: note?['title']);
    final bodyController = TextEditingController(text: note?['body']);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: bodyController,
                  decoration: InputDecoration(labelText: 'Body'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text('Save'),
                      onPressed: () {
                        final title = titleController.text;
                        final body = bodyController.text;

                        if (index == null) {
                          if (_selectedDay != null) {
                            _addNoteForDay(_selectedDay!, title, body);
                          }
                        } else {
                          _editNoteForDay(_selectedDay!, index, title, body);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

bool isSameDay(DateTime? day1, DateTime? day2) {
  if (day1 == null || day2 == null) {
    return false;
  }
  return day1.year == day2.year &&
      day1.month == day2.month &&
      day1.day == day2.day;
}
