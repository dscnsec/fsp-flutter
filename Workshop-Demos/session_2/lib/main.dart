import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: HomePage(),
    );
  }
}

/// Creates a [StatefulWidget].
///
/// StatefulWidgets are those having a [state], an entity (typically a variable) that
/// the UI if the widget depends upon.
///
/// The [StatefulWidget] is comprised of two classes: a main subclass of [StatefulWidget]
/// and another a subclass of [State].
///
/// The subclass of [StatefulWidget] contains a single function [StatefulWidget.createState]
/// that returns an object of the [State] subclass.
///
/// The subclass of [State] extends from a generic [State<T>] class, where [T] is the
/// class extending [StatefulWidget]. Its structure is very similar to any [StatelessWidget],
/// except a few additions.
///
/// The analogy is that the subclass of [State] is effectively a snapshot of [StatelessWidget],
/// each snapshot differing from the other in terms of appearance.
class HomePage extends StatefulWidget {
  /// Defines the pages corresponding to each tab in the [BottomNavigationBar].
  final _pages = [
    PageOne(),
    PageTwo(),
    PageThree(),
  ];
  @override
  _HomePageState createState() => _HomePageState();
}

/// The [State] subclass of the [StatefulWidget].
///
/// The class has been made private since it is useful only for the [StatefulWidget]
/// it is a part of.
class _HomePageState extends State<HomePage> {
  /// The state variable of this widget.
  int _currentPage = 0;

  @override
  Widget build(
    /// Describes the position of the widget in the widget tree.
    ///
    /// [BuildContext] passed to [build] function is actually a reference
    /// to the widget above this widget.
    ///
    /// This type of linking akin to a linked list with a previous node
    /// reference helps to obtain a value contained in a widget high up
    /// in the widget tree, if it is allowed, to the widgets lower in the
    /// tree.
    BuildContext context,
  ) {
    return Scaffold(
      endDrawer: Drawer(
        child: Center(
          child: Text('I am a Drawer'),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Notifier'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            tooltip: 'Search',
          ),

          /// The button that opens the drawer.
          DrawerButton(),
        ],
      ),

      /// The body of the widget, determined by the state.
      body: widget._pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPage,

        /// Changing the state of the widget, and making changes take effect.
        ///
        /// [State.setState] takes a [Function] parameter of return type
        /// [void] which changes the value of the state, then triggers a
        /// rebuild of the entire widget.
        ///
        /// ```dart
        /// void _increment(){ // Step 1: The UI invokes this action/function
        ///   setState( // Step 3: The widget is rebuilt
        ///     (){
        ///       counter++; // Step 2: Data/State gets changed
        ///     }
        ///   );
        /// }
        /// ```
        onTap: (int newPage) {
          setState(() {
            _currentPage = newPage;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Add'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            title: Text('Delete'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
        ],
      ),
    );
  }
}

/// A standalone [StatelessWidget] to be used in the main UI.
///
/// These widgets do not have a [state], thus inhibiting them from making
/// any changes in their appearance.
///
/// [Widget Refactoring] breaks the widget tree into various widget trees
/// (These widget trees may contain one or more than one widget). Breaking
/// up the widget tree helps in the following ways:
///
/// * By accessing values higher up the tree using the [BuildContext].
/// * By rebuilding less widgets, such that only those widgets that need a
///   change are rebuilt.
///
/// In this case, it is being used for the first purpose.
class DrawerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu),

      /// Using [ScaffoldState.of] to access the state of the [Scaffold] situated
      /// higher in the widget tree.
      ///
      /// The statement programatically opens [Scaffold.endDrawer].
      onPressed: () => Scaffold.of(context).openEndDrawer(),
      tooltip: 'Open Drawer',
    );
  }
}

/// One of the three pages of the app, switchable using [BottomNavigationBar].
///
/// Uses [Widget Refactoring] for the 2nd purpose above.
class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Text(
            'Hello $counter',
            style: TextStyle(fontSize: 60.0),
          ),
        ),
        RaisedButton(
          child: Text('Click Me!'),
          onPressed: _handleButtonTap,
        ),
      ],
    );
  }

  /// Defines a handler function for the [RaisedButton] of the page.
  void _handleButtonTap() {
    setState(() {
      counter++;
    });
  }
}

/// One of the three pages of the app, switchable using [BottomNavigationBar].
class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('This is Page two'),
    );
  }
}

/// One of the three pages of the app, switchable using [BottomNavigationBar].
class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Page Three'),
    );
  }
}
