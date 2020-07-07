import 'package:firebase_auth/firebase_auth.dart';

/// Contains a firebase instance and some helper functions for authentication.
class Auth {
  final FirebaseAuth _firebaseAuth;

  /// Initializes the [Auth] class.
  ///
  /// Uses initiailizer list to instantiate the [final] member.
  ///
  /// Statements in initializer list is always executed before any statements in the
  /// constructor.
  Auth() : _firebaseAuth = FirebaseAuth.instance;

  /// Logs in the user using an email and password.
  ///
  /// Uses asynchronous operation depicted by the [async] keyword. [await] is
  /// used for "awaiting" the result which is initially given a [Future], which
  /// is equivalent to `promises` in JavaScript.
  ///
  /// The [Future] then returns an instance of [FirebaseUser](if success), or an
  /// `error`(if failure) upon completion of the await statement.
  Future<FirebaseUser> signIn({String email, String password}) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  /// Signs up a new user using an email and password.
  Future<FirebaseUser> signUp({String email, String password}) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  /// Returns the current logged in user.
  ///
  /// If no user is logged in, returns [null].
  Future<FirebaseUser> get currentUser async =>
      await _firebaseAuth.currentUser();

  /// Signs out an user.
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
