import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'blank_note.dart';
import 'calendar_page.dart';
import 'tools_page.dart';
import 'profile_page.dart';
import 'drawer.dart';
import 'note_item.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String email;

  HomePage({required this.name, required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _notes = [
    {
      "title": "CROPS",
      "items": [NoteItem(content: "Harvested approximately 450 this month of June. Regularly check for pests and diseases, apply.")],
      "date": "2024-07-15 08:00:00",
    },
    {
      "title": "TODAY’S SCHEDULE",
      "items": [
        NoteItem(content: "Plant rice, onions, and tomatoes."),
        NoteItem(content: "Harvest lettuces and cucumbers.")
      ],
      "date": "2024-07-15 08:00:00",
    },
    {
      "title": "REPORTS",
      "items": [
        NoteItem(content: "Ensure adequate water supply, especially during dry spells."),
        NoteItem(content: "Follow recommended fertilization schedules to maintain soil fertility."),
        NoteItem(content: "Maintain detailed records of harvest dates, yields, and any issues.")
      ],
      "date": "2024-07-01 08:00:00",
    },
    {
      "title": "CROPLIST TO BUY",
      "items": [
        NoteItem(content: "Wheat"),
        NoteItem(content: "Corn"),
        NoteItem(content: "Carrots"),
        NoteItem(content: "Spinach"),
        NoteItem(content: "Strawberry"),
        NoteItem(content: "Orange"),
        NoteItem(content: "Apple")
      ],
      "date": "2024-07-08 08:00:00",
    },
    {
      "title": "TOOLS LIST",
      "items": [
        NoteItem(content: "Hoe - Used for weeding and soil cultivation."),
        NoteItem(content: "Shovel - Used for digging, moving soil, and planting.")
      ],
      "date": "2024-06-23 08:00:00",
    }
  ];
  List<Map<String, dynamic>> _filteredNotes = [];

  @override
  void initState() {
    super.initState();
    _filteredNotes = _notes;
  }

  void _filterNotes(String query) {
    final notes = _notes.where((note) {
      final noteLower = note['title'].toLowerCase() + note['items'].map((item) => item.content).join(' ').toLowerCase();
      final queryLower = query.toLowerCase();

      return noteLower.contains(queryLower);
    }).toList();

    setState(() {
      _filteredNotes = notes;
    });
  }

  void _addOrUpdateNote({
    required String? oldTitle,
    required String newTitle,
    required List<NoteItem> newItems,
    required String newDate,
  }) {
    setState(() {
      if (oldTitle != null) {
        _notes.removeWhere((note) => note['title'] == oldTitle);
      }
      _notes.insert(0, {"title": newTitle, "items": newItems, "date": newDate});
      _filteredNotes = _notes;
    });
  }

  void _deleteNote(String title) {
    setState(() {
      _notes.removeWhere((note) => note['title'] == title);
      _filteredNotes = _notes;
    });
  }

  void _showAddNoteOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.text_fields),
              title: Text('Plain Text'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlankNotePage(
                      noteType: NoteType.text,
                      onSave: (newTitle, newItems, newDate) => _addOrUpdateNote(
                        oldTitle: null,
                        newTitle: newTitle,
                        newItems: newItems,
                        newDate: newDate,
                      ),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.check_box),
              title: Text('Check List'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlankNotePage(
                      noteType: NoteType.checklist,
                      onSave: (newTitle, newItems, newDate) => _addOrUpdateNote(
                        oldTitle: null,
                        newTitle: newTitle,
                        newItems: newItems,
                        newDate: newDate,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terra Tales', style: TextStyle(color: Color(0xFF757121))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF757121)),
      ),
      drawer: AppDrawer(name: widget.name, email: widget.email, notes: {},),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Notes',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _filterNotes,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                itemCount: _filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = _filteredNotes[index];
                  final title = note['title'];
                  final items = note['items'] as List<NoteItem>;
                  final date = note['date'];
                  return Card(
                    child: ListTile(
                      title: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF757121),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...items.take(1).map((item) => Text(
                                item.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5), // Adjust line spacing here
                              )),
                          if (items.length > 1)
                            Text(
                              '...',
                              style: TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlankNotePage(
                              noteType: items.any((item) => item.isCheckbox) ? NoteType.checklist : NoteType.text,
                              title: title,
                              items: items,
                              date: date,
                              onSave: (newTitle, newItems, newDate) => _addOrUpdateNote(
                                oldTitle: title,
                                newTitle: newTitle,
                                newItems: newItems,
                                newDate: newDate,
                              ),
                              onDelete: () => _deleteNote(title),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteOptions,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF757121),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              color: Color(0xFF757121),
              onPressed: () {
                // Current page
              },
            ),
            IconButton(
              icon: Icon(Icons.calendar_today),
              color: Color(0xFF757121),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalendarPage(
                      name: widget.name,
                      email: widget.email,
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 40), // The dummy child
            IconButton(
              icon: Icon(Icons.build),
              color: Color(0xFF757121),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ToolsPage(
                      name: widget.name,
                      email: widget.email,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              color: Color(0xFF757121),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      name: widget.name,
                      email: widget.email,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
