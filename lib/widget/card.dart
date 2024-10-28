import 'package:bee_creative/models/creation.dart';
import 'package:flutter/material.dart';

class CreationCard extends StatefulWidget {
  final Creation creation;
  final String imageUrl;

  const CreationCard(
      {super.key, required this.creation, required this.imageUrl});

  @override
  _CreationCardState createState() => _CreationCardState();
}

class _CreationCardState extends State<CreationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              widget.imageUrl ?? "https://placehold.co/600x400",
              fit: BoxFit.cover,
            ),
          ),
          Text(
              '${widget.creation.creationDate.day.toString().padLeft(2, '0')}-${widget.creation.creationDate.month.toString().padLeft(2, '0')}-${widget.creation.creationDate.year}'),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CreationDetailsDialog(creation: widget.creation);
                  },
                );
              },
              child: const Icon(Icons.info),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CreationDetailsDialog(creation: widget.creation);
                  },
                );
              },
              child: const Icon(Icons.restart_alt),
            ),
          ]),
        ],
      ),
    );
  }
}

class CreationDetailsDialog extends StatelessWidget {
  final Creation creation;

  const CreationDetailsDialog({super.key, required this.creation});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Prompt: ${creation.prompt}'),
            Text('Model: ${creation.model}'),
            Text('Height: ${creation.height}'),
            Text('Width: ${creation.width}'),
            Text('Seed: ${creation.seed}'),
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
