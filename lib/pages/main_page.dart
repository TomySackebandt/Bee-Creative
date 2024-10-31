import 'dart:convert';
import 'package:bee_creative/models/collection.dart';
import 'package:bee_creative/models/creation.dart';
import 'package:bee_creative/pages/history.dart';
import 'package:bee_creative/pages/image_generation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;
  Collection? mycollection;

  @override
  void initState() {
    super.initState();
    _loadCollection();
  }

  void _saveCollection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(mycollection?.toJson());
    prefs.setString('collection', json);
  }

  void _loadCollection() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('collection');

    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      final collection = Collection.fromJson(jsonMap);
      setState(() {
        mycollection = collection;
      });
    } else {
      mycollection = Collection([]);
    }
  }

  void addNewCreation(Creation creation) {
    mycollection?.addCreation(creation);
    _saveCollection();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Row(children: [Icon(Icons.hive), Text('Bee Creative')]),
        actions: const <Widget>[
          IconButton(onPressed: null, icon: Icon(Icons.filter_vintage))
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.image_outlined),
            icon: Icon(Icons.image),
            label: 'Generate',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month_outlined),
            icon: Icon(Icons.calendar_month),
            label: 'History',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.message_outlined),
            icon: Icon(Icons.message),
            label: 'Chat',
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          /// Home page
          ImageGenerationPage(addCreationToCollection: addNewCreation),

          //History page,
          HistoryPage(
            mycollection: mycollection,
          ),

          /// Notifications page
          const Placeholder(),
        ],
      ),
    );
  }
}
