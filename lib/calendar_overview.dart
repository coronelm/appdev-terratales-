import 'package:flutter/material.dart';

class CalendarOverviewPage extends StatelessWidget {
  final Map<DateTime, List<Map<String, String>>> notes;

  CalendarOverviewPage({required this.notes});

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
      ),
      body: ListView(
        children: notes.entries
            .map((entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${entry.key.toLocal()}".split(' ')[0],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF757121),
                        ),
                      ),
                    ),
                    ...entry.value.map((note) => ListTile(
                          title: Text(note['title']!),
                          subtitle: Text(note['body']!),
                        )),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
