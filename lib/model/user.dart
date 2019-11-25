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

  Map<String, dynamic> toJson() {
    return<String, dynamic> {
      "displayName": "${this.displayName}",
      "email": "${this.email}",
      "photoUrl": "${this.photoUrl}",
      "firstName": "${this.firstName == null ? '' : this.firstName}",
    };
  }
  
}


class IZohoUser {
  String EmailID;
  String Date_of_birth;
  String Photo;
  String Male;
  String Bloodgroup;
  String Employeestatus;
  String Role;
  String Project;
  String Experience;
  String Business_HR;
  String LastName;
  String EmployeeID;
  String Other_Email;
  String Work_location;
  String LocationName;
  String Designation;
  String FirstName;
  String Dateofjoining;
  String Mobile;
  String Birth_Date_as_per_Records;
  String Hobbies;
  String Department;
  String Reporting_To;
  String Expertise;
  String empId;
  String accessType;

  IZohoUser({this.EmailID, this.Date_of_birth, this.Photo, this.Male, this.Bloodgroup, this.Employeestatus, 
            this.Role, this.Project, this.Experience, this.Business_HR, this.LastName, this.EmployeeID, 
            this.Other_Email, this.Work_location, this.LocationName, this.Designation, this.FirstName, 
            this.Dateofjoining, this.Mobile, this.Birth_Date_as_per_Records, this.Hobbies, this.Department, 
            this.Reporting_To, this.Expertise, this.empId, this.accessType});

  factory IZohoUser.fromJson(Map<String, dynamic> json) {
    return IZohoUser(
      EmailID: json['EmailID'],
      Date_of_birth: json['Date_of_birth'],
      Photo: json['Photo'],
      Male: json['Male'],
      Bloodgroup: json['Bloodgroup'],
      EmployeeID: json['EmployeeID'],
      Employeestatus: json['Employeestatus'],
      Role: json['Role'],
      Project: json['Project'],
      Experience: json['Experience'],
      Expertise: json['Expertise'],
      Business_HR: json['Business_HR'],
      LastName: json['LastName'],
      Other_Email: json['Other_Email'],
      Work_location: json['Work_location'],
      LocationName: json['LocationName'],
      Designation: json['Designation'],
      FirstName: json['FirstName'],
      Dateofjoining: json['Dateofjoining'],
      Mobile: json['Mobile'],
      Birth_Date_as_per_Records: json['Birth_Date_as_per_Records'],
      Hobbies: json['Hobbies'],
      Department: json['Department'],
      Reporting_To: json['Reporting_To'],
      empId: json['empId'],
      accessType: json['accessType'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return<String, dynamic> {
      "EmailID": "${this.EmailID}",
      "Date_of_birth": "${this.Date_of_birth}",
      "Photo": "${this.Photo}",
      "Male": "${this.Male}",
      "Bloodgroup": "${this.Bloodgroup}",
      "EmployeeID": "${this.EmployeeID}",
      "Employeestatus": "${this.Employeestatus}",
      "Role": "${this.Role}",
      "Project": "${this.Project}",
      "Experience": "${this.Experience}",
      "Expertise": "${this.Expertise}",
      "Business_HR": "${this.Business_HR}",
      "LastName": "${this.LastName}",
      "Other_Email": "${this.Other_Email}",
      "Work_location": "${this.Work_location}",
      "LocationName": "${this.LocationName}",
      "Designation": "${this.Designation}",
      "FirstName": "${this.FirstName}",
      "Dateofjoining": "${this.Dateofjoining}",
      "Mobile": "${this.Mobile}",
      "Birth_Date_as_per_Records": "${this.Birth_Date_as_per_Records}",
      "Hobbies": "${this.Hobbies}",
      "Department": "${this.Department}",
      "Reporting_To": "${this.Reporting_To}",
      "empId": "${this.empId}",
      "accessType": "${this.accessType}"
    };
  }
}