import 'package:english_words/english_words.dart';
import 'package:english_words/english_words.dart' as prefix0;
import 'package:flutter/material.dart';

import 'RandomWords.dart';

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Startup Name Generator"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list),
              onPressed: _pushSaved
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    // ListView.builder will create a scrollable, linear array of widgets
    // that are created on demand and called only for those children that are
    // actually "visible" (That mean it'll create each children until your app
    // have full of ListTile. When you scroll down, it'll create 1 more children
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // itemCount: 100,
        // itemBuilder will be called when indices >= 0 and indices < itemCount
        itemBuilder: /*1*/ (context, i) { // i is index of current children
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; // put ~ to return an integer result /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }

//          print(i);
          return _buildRow(_suggestions[index]);
        });
  }

  /*
      /*1*/ The itemBuilder callback is called once per suggested word pairing,
            and places each suggestion into a ListTile row. For even rows,
            the function adds a ListTile row for the word pairing.
            For odd rows, the function adds a Divider widget to visually
            separate the entries. Note that the divider might be difficult to
            see on smaller devices.
      /*2*/ Add a one-pixel-high divider widget before each row in the ListView.
      /*3*/ The expression i ~/ 2 divides i by 2 and returns an integer result.
            For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2. This calculates
            the actual number of word pairings in the ListView, minus the
            divider widgets.
      /*4*/ If you’ve reached the end of the available word pairings, then
            generate 10 more and add them to the suggestions list.

      The _buildSuggestions() function calls _buildRow() once per word pair.
      This function displays each new pair in a ListTile, which allows you to
      make the rows more attractive in the next step.
  */

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);

    print(pair.asPascalCase);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: IconButton( // interactive button that include Icon
        icon: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.redAccent : null,
        ),
        onPressed: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      ),
    );
  }

  // Navigate to other page
  void _pushSaved() {
    Navigator.of(context).push(
      // Add Route and its builder
      MaterialPageRoute<void>(
        builder: (context) {
          // tiles used for divided

          // Iterable is a collection
          // <set>.map() method will return Iterable that each elements can be
          // made by callback (return Widget)
          final Iterable<ListTile> tiles = _saved.map(
              (WordPair pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  )
                );
              }
          );

          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text("Saved Suggestions"),
            ),
            body: ListView(
              children: divided,
            ),
          );
        }
      )
    );
  }
}