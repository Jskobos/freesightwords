import 'package:flutter/material.dart';
import 'dart:async' show Future;

Future<WordList> loadAsset(BuildContext context) {
  return DefaultAssetBundle.of(context)
      .loadString('assets/sightwords.txt')
      .then((response) {
    final words = response
        .split('\n')
        .map((thisWord) => SightWord(word: thisWord))
        .toList();
    return WordList(words: words);
  });
}

class SightWord {
  final String word;

  SightWord({this.word});
}

class WordList {
  final List<SightWord> words;

  WordList({this.words});
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sight Words Practice',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
              bodyText2: TextStyle(color: Colors.white, fontSize: 200))),
      home: MyHomePage(title: 'Free Sightwords'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<WordList>(
            future: loadAsset(context),
            builder: (BuildContext context, AsyncSnapshot<WordList> snapshot) {
              if (snapshot.hasData) {
                return SingleWordView(words: snapshot.data);
              } else {
                return Center(child: Text('Loading...'));
              }
            }));
  }
}

class SingleWordView extends StatefulWidget {
  SingleWordView({Key key, this.words}) : super(key: key);

  final WordList words;

  @override
  _SingleWordViewState createState() => _SingleWordViewState();
}

class _SingleWordViewState extends State<SingleWordView> {
  int _currentWord = 0;
  int _totalWords;

  void _nextWord() {
    this.setState(() {
      if (_currentWord < (_totalWords - 1)) {
        _currentWord++;
      } else {
        _currentWord = 0;
      }
    });
  }

  void _shuffle() {}

  @override
  void initState() {
    super.initState();
    _totalWords = widget.words.words.length;
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        this._nextWord();
      },
      child: Container(
        child: Center(child: Text(widget.words.words[_currentWord].word)),
      ),
    );
  }
}
