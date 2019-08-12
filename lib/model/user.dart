class IUser {
  String displayName;
  String email;
  String photoUrl;
  String firstName;
  IUser({this.displayName, this.email, this.photoUrl, this.firstName});

  factory IUser.fromJson(Map<String, dynamic> json) {
    return IUser(
      displayName: json['displayName'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      firstName: json['firstName'] == null ? "" : json['firstName'],
    );
  }
  
}