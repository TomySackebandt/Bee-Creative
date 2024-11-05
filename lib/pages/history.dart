import 'package:bee_creative/models/collection.dart';
import 'package:bee_creative/widget/card.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final Collection? mycollection;

  const HistoryPage({super.key, this.mycollection});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return widget.mycollection != null && widget.mycollection!.creations != []
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              childAspectRatio: 1, // Aspect ratio of each child
              crossAxisSpacing: 10, // Spacing between columns
              mainAxisSpacing: 10, // Spacing between rows
            ),
            itemCount: widget.mycollection!.creations.length,
            itemBuilder: (BuildContext context, int index) {
              final creation = widget.mycollection!.creations[index];

              return CreationCard(
                creation: creation,
              );
            },
          )
        : const Text("No creations found");
  }
}
