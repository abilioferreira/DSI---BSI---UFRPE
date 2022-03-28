import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Startup Name Generator',
        home: RandomWords());
  }
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppController.instance,
        builder: (context, child) {
          return MaterialApp(
              home: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'StartUp Name Generator',
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      Center(
                        child: Switch(
                          value: AppController.instance.isSwitched,
                          onChanged: (value) {
                            AppController.instance.changeView();
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: _pushSaved,
                        icon: const Icon(Icons.list),
                        tooltip: 'Saved Suggestions',
                      )
                    ],
                    titleTextStyle: TextStyle(color: Colors.white),
                    backgroundColor: Colors.deepPurple,
                  ),
                  body: AppController.instance.isSwitched
                      ? Grid()
                      : suggestions()));
        });
  }

  Widget Grid() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 3,
      children: List.generate(_suggestions.length, (int i) {
        final index = i ~/ 2;
        if (i >= _suggestions.length || _suggestions.length <= 0) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return buildRow(_suggestions[i]);
      }),
    );
  }

  Widget suggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return Divider();
        }
        final int index = i ~/ 2;

        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return buildRow(_suggestions[index]);
      },
    );
  }

  Widget buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      tileColor: Colors.white,
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        semanticLabel: alreadySaved ? 'Remove from favorites' : 'Save',
        color: alreadySaved ? Colors.deepPurple : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute
    <void>(builder: (context) {
      final tiles = _saved.map((pair) {
        return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ));
      });
      final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(context: context, tiles: tiles).toList()
          : <Widget>[];

      return Scaffold(
        appBar: AppBar(
          title: const Text("Saved Suggestions"),
        ),
        body: ListView(children: divided),
      );
    }));
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class AppController extends ChangeNotifier {
  static AppController instance = AppController();
  bool isSwitched = false;
  changeView() {
    isSwitched = !isSwitched;
    notifyListeners();
  }
}
