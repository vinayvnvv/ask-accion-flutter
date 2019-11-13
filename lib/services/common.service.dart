class CommonService {
  getEmpAccessType(String department) {
    String role = 'normal';
    if(department == 'Management' || department == 'Human Resource') role = 'Admin';
    return role;
  }
}