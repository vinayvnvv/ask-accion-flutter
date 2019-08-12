class IPoepleList {
  String EmailID;
  String Photo;
  String FirstName;
  String LastName;
  IPoepleList({this.EmailID, this.Photo, this.FirstName, this.LastName});

  factory IPoepleList.fromJson(Map<String, dynamic> json) {
    return IPoepleList(
      EmailID: json['EmailID'],
      Photo: json['Photo'],
      FirstName: json['FirstName'],
      LastName: json['LastName'],
    );
  }

  // factory List<IMenu>.fromArrayJson(Map<String, dynamic> json) {
  //   List<IMenu> menus = [];
  //   json.forEach((menu) {
  //     menus.add(IMenu(
  //       icon: menu['icon'],
  //       name: menu['name'],
  //       desc: menu['desc']
  //     ));
  //   });
  //   return menus;
  // }
  
}