/// Stores details of the currently logged in user.
class User{
  /// The user id, received from the response of the Firebase API.
  String id;
  /// The email of the user, received from the response of the Firebase API.
  String email;
  /// The constructor of [User] class.
  /// 
  /// Uses optional named parameters(enclosing by `{}`).
  User({this.id, this.email});
}