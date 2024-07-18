import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'note_item.dart';  // Import NoteItem

enum NoteType { text, checklist }

class BlankNotePage extends StatefulWidget {
  final NoteType noteType;
  final String? title;
  final List<NoteItem>? items;
  final String? date;
  final void Function(String, List<NoteItem>, String) onSave;
  final VoidCallback? onDelete;

  BlankNotePage({
    required this.noteType,
    this.title,
    this.items,
    this.date,
    required this.onSave,
    this.onDelete,
  });

  @override
  _BlankNotePageState createState() => _BlankNotePageState();
}

class _BlankNotePageState extends State<BlankNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _dateController;
  List<NoteItem> _items = [];
  bool _bold = false;
  bool _italic = false;
  bool _underline = false;
  Color _textColor = Colors.black;
  Color _bgColor = Colors.transparent;
  double _fontSize = 13.0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController();
    _dateController = TextEditingController(text: widget.date ?? DateTime.now().toString().substring(0, 10));
    _items = widget.items ?? [];
    if (widget.noteType == NoteType.text && _items.isNotEmpty) {
      _contentController.text = _items.first.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _addItem() {
    final newItem = NoteItem(content: _contentController.text, isCheckbox: widget.noteType == NoteType.checklist);
    setState(() {
      _items.add(newItem);
      _contentController.clear();
    });
  }

  void _toggleCheckbox(int index) {
    setState(() {
      _items[index].isChecked = !_items[index].isChecked;
    });
  }

  void _editItem(int index, String newContent) {
    setState(() {
      _items[index].content = newContent;
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _saveNote() async {
    final String date = DateTime.now().toString().substring(0, 19);
    bool? confirm = await _showConfirmationDialog(context, 'Save Note', 'Do you want to save this note?');
    if (confirm ?? false) {
      if (widget.noteType == NoteType.text) {
        _items = [NoteItem(content: _contentController.text)];
      }
      widget.onSave(_titleController.text, _items, date);
      Navigator.pop(context);
    }
  }

  Future<void> _confirmDelete() async {
    bool? confirm = await _showConfirmationDialog(context, 'Delete Note', 'Are you sure you want to delete this note?');
    if (confirm ?? false) {
      if (widget.onDelete != null) {
        widget.onDelete!();
        Navigator.pop(context);
      }
    }
  }

  Future<void> _confirmDiscardChanges() async {
    bool? confirm = await _showConfirmationDialog(context, 'Discard Changes', 'Are you sure you want to discard your changes?');
    if (confirm ?? false) {
      Navigator.pop(context);
    }
  }

  Future<bool?> _showConfirmationDialog(BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _confirmDiscardChanges();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ALL NOTES',
            style: TextStyle(color: Color(0xFF757121)),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF757121)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _confirmDiscardChanges,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete, color: Color(0xFF757121)),
              onPressed: _confirmDelete,
            ),
            IconButton(
              icon: Text(
                'Done',
                style: TextStyle(color: Color(0xFF757121)),
              ),
              onPressed: _saveNote,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF757121),
                ),
                decoration: InputDecoration(
                  hintText: 'TITLE',
                  border: InputBorder.none,
                ),
              ),
              if (widget.noteType == NoteType.text)
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Content...',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
                      fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
                      decoration: _underline ? TextDecoration.underline : TextDecoration.none,
                      color: _textColor,
                      backgroundColor: _bgColor,
                      height: 1.5, // Adjust line spacing here
                    ),
                  ),
                ),
              if (widget.noteType == NoteType.checklist)
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.0), // Adjust padding between items here
                        child: Row(
                          children: [
                            Checkbox(
                              value: item.isChecked,
                              onChanged: (bool? value) {
                                _toggleCheckbox(index);
                              },
                            ),
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(text: item.content),
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onChanged: (newContent) {
                                  _editItem(index, newContent);
                                },
                                style: TextStyle(
                                  fontSize: _fontSize,
                                  fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
                                  fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
                                  decoration: item.isCheckbox && item.isChecked
                                      ? TextDecoration.lineThrough
                                      : _underline
                                          ? TextDecoration.underline
                                          : TextDecoration.none,
                                  color: _textColor,
                                  backgroundColor: _bgColor,
                                  height: 1.2, // Adjust line spacing here
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              if (widget.noteType == NoteType.checklist)
                TextField(
                  controller: _contentController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'New item...',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addItem,
                    ),
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 5.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.format_bold, color: _bold ? Colors.black : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _bold = !_bold;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.format_italic, color: _italic ? Colors.black : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _italic = !_italic;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.format_underline, color: _underline ? Colors.black : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _underline = !_underline;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.format_color_text, color: _textColor),
                  onPressed: _pickTextColor,
                ),
                IconButton(
                  icon: Icon(Icons.format_color_fill, color: _bgColor),
                  onPressed: _pickBackgroundColor,
                ),
                DropdownButton<double>(
                  value: _fontSize,
                  icon: Icon(Icons.arrow_drop_down, color: Color(0xFF757121)),
                  onChanged: (double? newValue) {
                    setState(() {
                      _fontSize = newValue!;
                    });
                  },
                  items: <double>[10, 12, 13, 15, 18, 20, 24, 30, 36]
                      .map<DropdownMenuItem<double>>((double value) {
                    return DropdownMenuItem<double>(
                      value: value,
                      child: Text(value.toString(), style: TextStyle(color: Color(0xFF757121))),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickTextColor() async {
    Color newColor = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pick a text color'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _textColor,
            onColorChanged: (color) {
              Navigator.of(context).pop(color);
            },
          ),
        ),
      ),
    );
    setState(() {
      _textColor = newColor;
    });
  }

  void _pickBackgroundColor() async {
    Color newColor = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pick a background color'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _bgColor,
            onColorChanged: (color) {
              Navigator.of(context).pop(color);
            },
          ),
        ),
      ),
    );
    setState(() {
      _bgColor = newColor;
    });
  }
}
