class IListView {
  String title;
  String desc;
  List<String> sections;
  IListView({this.title, this.desc, this.sections});

  factory IListView.fromJson(Map<String, dynamic> json) {
    var sections = json['sections'] as List;
    return IListView(
      title: json['title'],
      desc: json['desc'],
      sections: sections != null ? new List<String>.from(sections) : [],
    );
  }
  
}