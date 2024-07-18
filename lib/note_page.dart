import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NotePage extends StatefulWidget {
  final String title;
  final String content;
  final List<bool> checkListValues;
  final ValueChanged<Map<String, dynamic>> onUpdate;
  final VoidCallback onDelete;

  NotePage({
    required this.title,
    required this.content,
    required this.checkListValues,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  List<bool> _checkListValues = [];
  bool _bold = false;
  bool _italic = false;
  bool _underline = false;
  Color _textColor = Colors.black;
  Color _bgColor = Colors.transparent;
  double _fontSize = 13.0;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _contentController.text = widget.content;
    _checkListValues = List.from(widget.checkListValues);
  }

  void _addCheckBox() {
    setState(() {
      _checkListValues.add(false);
      _contentController.text += '\n';
    });
  }

  void _toggleCheckBox(int index, bool value) {
    setState(() {
      _checkListValues[index] = value;
    });
  }

  void _undoChanges() {
    setState(() {
      _titleController.clear();
      _contentController.clear();
      _checkListValues.clear();
      _bold = false;
      _italic = false;
      _underline = false;
      _textColor = Colors.black;
      _bgColor = Colors.transparent;
      _fontSize = 13.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ALL NOTES',
          style: TextStyle(color: Color(0xFF757121)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF757121)),
        actions: [
          IconButton(
            icon: Icon(Icons.undo, color: Color(0xFF757121)),
            onPressed: _undoChanges,
          ),
          IconButton(
            icon: Text(
              'Done',
              style: TextStyle(color: Color(0xFF757121)),
            ),
            onPressed: () {
              widget.onUpdate(
                {
                  'title': _titleController.text,
                  'content': _contentController.text,
                  'checkListValues': _checkListValues,
                },
              );
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Color(0xFF757121)),
            onPressed: () {
              widget.onDelete();
              Navigator.pop(context);
            },
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
            Expanded(
              child: ListView.builder(
                itemCount: _contentController.text.split("\n").length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      if (_checkListValues.isNotEmpty && index < _checkListValues.length)
                        Checkbox(
                          value: _checkListValues[index],
                          onChanged: (value) {
                            _toggleCheckBox(index, value!);
                          },
                        ),
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(
                              text: _contentController.text.split("\n")[index]),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (text) {
                            List<String> lines = _contentController.text.split("\n");
                            lines[index] = text;
                            _contentController.text = lines.join("\n");
                          },
                          style: TextStyle(
                            fontSize: _fontSize,
                            fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
                            fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
                            decoration: _underline ? TextDecoration.underline : TextDecoration.none,
                            color: _textColor,
                            backgroundColor: _bgColor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
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
                icon: Icon(Icons.check_box_outlined, color: Color(0xFF757121)),
                onPressed: _addCheckBox,
              ),
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
                onPressed: () {
                  _pickTextColor();
                },
              ),
              IconButton(
                icon: Icon(Icons.format_color_fill, color: _bgColor),
                onPressed: () {
                  _pickBackgroundColor();
                },
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
