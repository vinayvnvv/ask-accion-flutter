class BalanceListView {
  final String title;
  final String desc;
  final bool disableClick;

  BalanceListView({this.title, this.desc, this.disableClick});

  factory BalanceListView.fromJson(Map<String, dynamic> json) {
    return BalanceListView(
        title: json['title'],
        desc: json['desc'],
        disableClick: json['disableClick']);
  }
}

/*
class LeaveBalance {
  final String type;
  final String msg;
  final String from;
  final List<BalanceListView> listView;

  LeaveBalance({this.type, this.msg, this.from, this.listView});

  factory LeaveBalance.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['listView'] as List;
    print("LIST====> $list");
    List<BalanceListView> balanceList =
        list.map((i) => BalanceListView.fromJson(i)).toList();

    return LeaveBalance(
      type: parsedJson['type'],
      msg: parsedJson['msg'],
      from: parsedJson['from'],
      listView: balanceList,
    );
  }
}

class BalanceListView {
  final String title;
  final String desc;
  final bool disableClick;

  BalanceListView({this.title, this.desc, this.disableClick});

  factory BalanceListView.fromJson(Map<String, dynamic> json) {
    return BalanceListView(
        title: json['title'],
        desc: json['desc'],
        disableClick: json['disableClick']);
  }
}
*/
