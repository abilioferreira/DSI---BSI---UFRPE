import 'package:flutter/material.dart';

class Edition extends StatefulWidget {
  late String startupFirstWord;
  late String startupSecondWord;

  Edition({Key? key}) : super(key: key);
  @override
  State<Edition> createState() => editSection(startupFirstWord, startupSecondWord);
}
class editSection extends State<Edition> {editSection(this.startupFirstWord, this.startupSecondWord);
  late String startupFirstWord;
  late String startupSecondWord;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (value) => {startupFirstWord = value},
                  decoration: InputDecoration(
                      labelText: 'First Word',
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (value) => {startupSecondWord = value},
                  decoration: InputDecoration(
                      labelText: 'Second Word',
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 13,
                ),
                RaisedButton(
                  onPressed: () {
                    List<String> newWord() {
                      List<String> lista = [startupFirstWord, startupSecondWord];
                      return lista;
                    }
                  },
                  child: Text('Editar'),
                )
              ],),),),),);}

  List<String> newWord() {
    List<String> newWordList = [startupFirstWord, startupSecondWord];
    return newWordList;
  }
}