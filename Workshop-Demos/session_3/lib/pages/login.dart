import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:session_3/utils/auth.dart';

/// The login page of the app.
class Login extends StatefulWidget {
  final Auth auth;

  /// The callback to be invoked when a login/signup is registered.
  final VoidCallback loginCallback;

  Login({this.auth, this.loginCallback});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isNewUser;
  String _userPassword;
  String _userEmail;

  /// Uniquely identifies a widget(as generics) throughout the
  /// widget tree.
  /// 
  /// Uses [FormState] to obtain the state of the [Form] widget
  /// from the same [BuildContext].
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isNewUser = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          (isNewUser) ? 'SIGN IN' : 'LOGIN',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 32.0,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                /// Displays an svg image.
                /// 
                /// Flutter does not have out-of-the-box support for svg
                /// assets, but can be implemented using packages.
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                ),
              ),
              /// Creates a Material Card.
              Card(
                elevation: 6.0,
                child: Container(
                  /// Uses [MediaQuery.of] to obtain the width and height of the viewport.
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(16.0),
                  /// A widget that contains several [FormFields].
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        /// A text form field.
                        /// 
                        /// [TextFormField.keyboardType] is used to "request" the system to
                        /// provide an appropriate keyboard for the [TextFormField]. For 
                        /// instance, using [TextInputType.emailAddress] gives a keyboard 
                        /// with handy access to symbols usually used in an email address,
                        /// like the `@` symbol.
                        /// 
                        /// [TextFormField.decoration] is used for providing borders, colors,
                        /// and any hint/label text.
                        /// 
                        /// [TextFormField.onSaved] is used for "saving" the inputs given which
                        /// can be used for other purposes, although it isn't required to do so.
                        /// 
                        /// [TextFormField.validation] is used to "validating" the inputs, and
                        /// should return a [String] if the inputs is incorrect. This string would
                        /// be displayed as an error under the [TextFormField]. Returns [null] if 
                        /// the input is correct instead.
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onSaved: (String input) {
                            _userEmail = input;
                          },
                          validator: (String input) {
                            if (input.isEmpty) {
                              return 'Email cannot be empty';
                            }
                            return null;
                          },
                        ),
                        /// Uses [TextFormField.obsureText] to "hide" the input.
                        /// 
                        /// Used especially for password fields.
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onSaved: (String input) {
                            _userPassword = input;
                          },
                          validator: (String input) {
                            if (input.isEmpty) {
                              return 'Password cannot be empty';
                            }
                            return null;
                          },
                        ),
                        /// A widget which is akin to a [Row], but for buttons.
                        ButtonBar(
                          children: <Widget>[
                            if (!isNewUser)
                              FlatButton(
                                child: Text('Forgot Password?'),
                                onPressed: () {},
                              ),
                            RaisedButton(
                              child: Text((isNewUser) ? 'Sign up' : 'Login'),
                              onPressed: _handleLogin,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              FlatButton(
                child: Text((!isNewUser)
                    ? 'New user? Sign up instead.'
                    : 'Already an user? Login instead.'),
                onPressed: () {
                  setState(() {
                    isNewUser = !isNewUser;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Handles login/sign up button press.
  /// 
  /// First checks the inputs given using the current state of the [GlobalKey]
  /// given to the [Form] and running the validation callback of each of the
  /// [FormFields]. Then, saves the inputs and calls either [Auth.signUp] or 
  /// [Auth.signIn] depending on whether the user is signing up or logging in.
  void _handleLogin() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        if (isNewUser) {
          await widget.auth.signUp(email: _userEmail, password: _userPassword);
          print('Signed in');
        } else {
          await widget.auth.signIn(email: _userEmail, password: _userPassword);
          print('Logged in');
        }
        widget.loginCallback();
        Navigator.of(context).pop();
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
