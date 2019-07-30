class IUser {
  String displayName;
  String email;
  String photoUrl;
  IUser({this.displayName, this.email, this.photoUrl});

  factory IUser.fromJson(Map<String, dynamic> json) {
    return IUser(
      displayName: json['displayName'],
      email: json['email'],
      photoUrl: json['photoUrl']
    );
  }
  
}