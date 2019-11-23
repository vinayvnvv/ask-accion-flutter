class CommonService {
  getEmpAccessType(String department, String empRole) {
    String role = 'normal';
    if(department == 'Management' || 
        department == 'Human Resource' || 
        empRole == 'Admin' ||
        empRole == 'Manager' ||
        department == 'Leadership') role = 'Admin';
    return role;
  }
}