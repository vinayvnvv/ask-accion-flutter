class IMenu {
  String icon;
  String name;
  String desc;
  IMenu({this.icon, this.name, this.desc});

  factory IMenu.fromJson(Map<String, dynamic> json) {
    return IMenu(
      icon: json['icon'],
      name: json['name'],
      desc: json['desc']
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