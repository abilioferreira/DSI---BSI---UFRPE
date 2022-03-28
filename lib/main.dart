import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  My_App createState() => My_App();
}
class My_App extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Startup Generator',
        home: RandomWords());
  }
}
class _RandomWordsState extends State<RandomWords> {
  final wordSuggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  // Variáveis dos nomes das Startups
  late String startupFirstWord; late String startupSecondWord;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Controller.instance,
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
                          value: Controller.instance.isSwitched,
                          onChanged: (value) {
                            Controller.instance.changeView();
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
                  body: Controller.instance.isSwitched
                      ? Grid()
                      : Suggestions()));});
  }
  Widget Grid() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 3,
            crossAxisSpacing:5, mainAxisSpacing: 16),
        itemBuilder: (BuildContext ctx, index) {
          final int index_qtd = index;
          if (index_qtd >= wordSuggestions.length) {
            wordSuggestions.addAll(generateWordPairs().take(100));
          }
          return buildRow(wordSuggestions[index_qtd]);
        });
  }

  Widget Suggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return Divider();
        }
        final int index = i ~/ 2;
        if (index >= wordSuggestions.length) {
          wordSuggestions.addAll(generateWordPairs().take(10));
        }
        return buildRow(wordSuggestions[index]);
      },);
  }
  Widget buildRow(WordPair pair) {
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
        ), body: ListView(children: divided),
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
        child: SizedBox(width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (value) => {startupFirstWord = value},
                  decoration: InputDecoration(
                      labelText: "First Word",
                      border: OutlineInputBorder()),
                ),
                SizedBox(height: 10,
                ),
                TextField(
                  onChanged: (value) => {startupSecondWord = value},
                  decoration: InputDecoration(
                      labelText: "Second Word",
                      border: OutlineInputBorder()),
                ),
                SizedBox(height: 13,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {setState(() {wordSuggestions[wordSuggestions.indexOf(pair)] = WordPair(startupFirstWord, startupSecondWord);});
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
                        onPressed: () {setState(() {wordSuggestions.remove(wordSuggestions[wordSuggestions.indexOf(pair)]); });
                        Navigator.pop(context);
                        },
                        child: Text("Delete word"),
                        color: Colors.white10
                    ),
                  ),)],),),),),);}
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}
class Controller extends ChangeNotifier {
  static Controller instance = Controller();

  bool isSwitched = false;
  changeView() {isSwitched = !isSwitched;
    notifyListeners();
  }
}
