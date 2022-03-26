import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Startup Generator',
        home: RandomWords());
  }
}
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  // Variáveis dos nomes das Startups
  late String StartupFirstWord; late String StartupSecondWord;

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
                      ? _buildGridView()
                      : _buildSuggestions()));
        });
  }

  Widget _buildGridView() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing:5,
            mainAxisSpacing: 16),
        itemBuilder: (BuildContext ctx, index) {
          final int index_qtd = index;
          if (index_qtd >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));

          }
          return _buildRow(_suggestions[index_qtd]);
        }
    );
  }

  Widget _buildSuggestions() {
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
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      tileColor: Colors.white,
      trailing: GestureDetector(
        child: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.deepPurple : null,
          semanticLabel: alreadySaved ? 'Remove from favorites' : 'Save',
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
      ),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => WordsEdition(context, pair)));
      },
    );
  }
  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
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
  Widget WordsEdition(BuildContext context, WordPair pair) {
    return Scaffold(appBar: AppBar(
        title: Text("Edition Page"),
        //style: _biggerFont, nao entendi pq nao da pra deixar _biggerfont(rever isso)
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (value) => {StartupFirstWord = value},
                  decoration: InputDecoration(
                      labelText: "First Word",
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (value) => {StartupSecondWord = value},
                  decoration: InputDecoration(
                      labelText: "Second Word",
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 13,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {setState(() {_suggestions[_suggestions.indexOf(pair)] = WordPair(StartupFirstWord, StartupSecondWord);});
                      Navigator.pop(context);
                      },
                      child: Text("Edit word"),
                      color: Colors.white10,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {setState(() {_suggestions.remove(_suggestions[_suggestions.indexOf(pair)]); });
                      Navigator.pop(context);
                      },
                      child: Text("Delete word"),
                      color: Colors.white10
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
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
