//import the flutter package alongwith widgets for Material Design
import 'package:flutter/material.dart';

void main() {
  runApp(App()); //runs the widget denoting the entire app
}

//Converting a Dart class to a "widget" by inheriting
class App extends StatelessWidget {
  @override
  //this function returns the set of widgets(say, the widgets
  //under it in the widget tree) to be built by the Flutter Engine
  Widget build(BuildContext context) {
    //a widget that implements "Material Design" throughout the app
    //Material Design is _highly_ customizable
    return MaterialApp(
      title: 'My App',
      //Passing the widget that we wish to see after the splash screen
      //when we launch the app
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //a widget that provides a "template" for designing any
    //app following "Material Design"
    return Scaffold(
      //Passing a widget which denotes the AppBar, commonly known
      //as a navigation bar in other platforms
      appBar: AppBar(
        backgroundColor: Colors.green,
        //a typical use to display the title of the app
        title: Text('Notifier'),
      ),
      //a widget that is equivalent to <div> in HTML and "contains"
      //any widget as a "child"
      //the "child" is then represented below this widget in the
      //widget tree
      //provides alignment, padding, margin, background color to the
      //containing widget
      body: Container(
        alignment: Alignment.center,
        //a widget that displays a string of text, equivalent to
        //"TextView" in Android native
        child: Text(
          'Hello Flutter',
          //text styling. Here, used to increase the font size denoted
          //in floating-point decimal pixels
          style: TextStyle(
            fontSize: 92.0,
          ),
        ),
      ),
    );
  }
}
