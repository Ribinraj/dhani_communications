class Endpoints {
  static const baseUrl = 'https://app.dhanigroups.com/api/';
  static const sendOtp = 'login';
  static const verifyOtp = 'login/verify';
  static const resendOtp = 'login/resend';
  static const getUpdates = 'login/updates';
  static const getProfile = 'login/profile';
  static const updateProfile = 'login/updateprofile';
  static const getProjects = 'login/projects';
  static const getVehicles = 'login/vehicles';
  static const getHeadquarterVehicles = 'login/headquartervehicles';
  static const updateVehicle = 'login/updatevehicle';
  static const getNotifications = 'login/notifications';
  static const updateNotification = 'login/updatenotification';
  
  // Attendance endpoints
  static const checkAttendance = 'attendance/check';
  static const createAttendance = 'attendance/new';
  static const getAttendanceList = 'attendance/list';
  
  // Labor Attendance endpoints
  static const getLaborAttendanceList = 'laborattendance/list';
  static const createLaborAttendance = 'laborattendance/new';
  static const getPunchInList = 'laborattendance/punchinlist';
  
  // Expenses endpoints
  static const createExpense = 'expenses/new';
  static const getExpensesList = 'expenses/list';
  
  // Leaves endpoints
  static const createLeave = 'leaves/new';
  static const getLeavesList = 'leaves/list';
  
  // DPR endpoints
  static const getDprList = 'dpr/list';
  static const getDprDetails = 'dpr/details';
  static const updateDpr = 'dpr/dprupdate';
  static const getMyDprSubmissions = 'dpr/mysubmissions';
}