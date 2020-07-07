import 'package:flutter/material.dart';
import 'package:session_3/data/user.dart';
import 'package:session_3/pages/login.dart';
import 'package:session_3/utils/auth.dart';


/// The status of the authentication.
/// 
/// Uses an [enum] to define two constants, [AuthStatus.LOGGEDIN],
/// and [AuthStatus.LOGGEDOUT], each of which have their own indices
/// starting from zero.
enum AuthStatus {
  LOGGEDIN,
  LOGGEDOUT,
}

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: HomePage(
        auth: Auth(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Auth auth;

  HomePage({this.auth});
  final _pages = [
    PageOne(),
    PageTwo(),
    PageThree(),
  ];
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user;
  int _currentPage;
  AuthStatus _authStatus;

  /// Initializes the state variables of this [StatefulWidget].
  /// 
  /// [super.initstate] must be called for using this.
  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    widget.auth.currentUser.then(
      (user) => setState(
        () {
          if (
            /// Uses null aware member access operator.
            /// 
            /// `user?.uid` is a short form of the following construct
            /// 
            /// ```dart
            /// if(user == null){
            ///   return null;
            /// }else{
            ///   return user.uid;
            /// }
            /// ```
            user?.uid != null) {
            _authStatus = AuthStatus.LOGGEDIN;
            this.user = User(email: user.email, id: user.uid);
          } else {
            _authStatus = AuthStatus.LOGGEDOUT;
            this.user = User();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = _authStatus == AuthStatus.LOGGEDIN;
    return Scaffold(
      endDrawer: Drawer(
        child: _buildDrawerItems(isLoggedIn),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Notifier'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            tooltip: 'Search',
          ),
          DrawerButton(),
        ],
      ),
      body: widget._pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPage,
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

  Widget _buildDrawerItems(bool isLoggedIn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            isLoggedIn ? 'User: ${user.email}' : 'User: Guest',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              color: Colors.white,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text(isLoggedIn ? 'Logout' : 'Login'),
          onTap: () {
            isLoggedIn ? _handleLogoutIntent() : _handleLoginIntent();
          },
        )
      ],
    );
  }

  /// Handles the Login button press.
  /// 
  /// Uses [Navigator.of] to first "pop" the [Drawer] off the Navigation
  /// stack, bringing back the [HomePage], then "pushes" [Login] page on
  /// top of the [HomePage].
  void _handleLoginIntent() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            Login(auth: widget.auth, loginCallback: loginCallback),
      ),
    );
  }

  /// The callback whenever there is a login/signup registered.
  /// 
  /// Updates the state variables of [HomePage] to reflect changes.
  void loginCallback() {
    widget.auth.currentUser.then(
      (firebaseUser) => setState(
        () {
          user.email = firebaseUser.email;
          user.id = firebaseUser.uid;
          _authStatus = AuthStatus.LOGGEDIN;
        },
      ),
    );
  }

  /// Handles the logout button press.
  /// 
  /// Signs off the user using [Auth.signOut] and then "pops" off the
  /// drawer from the Navigation stack.
  void _handleLogoutIntent() async {
    try {
      await widget.auth.signOut();
      print('Logged out');
      setState(() {
        _authStatus = AuthStatus.LOGGEDOUT;
        user = User();
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }
}

class DrawerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () => Scaffold.of(context).openEndDrawer(),
      tooltip: 'Open Drawer',
    );
  }
}

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
            style: TextStyle(
              fontSize: 60.0,
              /// The fontfamily to be used to display the text.
              /// 
              /// Must be the same as written on `pubspec.yaml.`
              fontFamily: 'JetBrains Mono',
            ),
          ),
        ),
        RaisedButton(
          child: Text('Click Me!'),
          onPressed: _handleButtonTap,
        ),
      ],
    );
  }

  void _handleButtonTap() {
    setState(() {
      counter++;
    });
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('This is Page two'),
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Page Three'),
    );
  }
}
