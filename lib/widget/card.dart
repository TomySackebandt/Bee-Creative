import 'dart:io';

import 'package:bee_creative/models/creation.dart';
import 'package:flutter/material.dart';

class CreationCard extends StatefulWidget {
  final Creation creation;

  CreationCard({super.key, required this.creation});

  @override
  _CreationCardState createState() => _CreationCardState();
}

class _CreationCardState extends State<CreationCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CreationDetailsPage(creation: widget.creation)),
        );
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.file(
                File(widget.creation.filePath),
                fit: BoxFit.cover,
              ),
            ),
            Text(
                '${widget.creation.creationDate.day.toString().padLeft(2, '0')}-${widget.creation.creationDate.month.toString().padLeft(2, '0')}-${widget.creation.creationDate.year}'),
          ],
        ),
      ),
    );
  }
}

class CreationDetailsPage extends StatelessWidget {
  final Creation creation;

  const CreationDetailsPage({super.key, required this.creation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creation Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(
              File(creation.filePath),
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height / 2,
            ),
            SelectableText('Prompt: ${creation.prompt}'),
            SelectableText('Model: ${creation.model}'),
            SelectableText('Height: ${creation.height}'),
            SelectableText('Width: ${creation.width}'),
            SelectableText('Seed: ${creation.seed}'),
            Text('Creation Date: ${creation.creationDate.toString()}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
