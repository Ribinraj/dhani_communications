class Endpoints {
  static const baseUrl = 'https://test.dhanigroups.com/api/';
  // static const baseUrl = 'https://app.dhanigroups.com/api/';
  static const sendOtp = 'login';
  static const verifyOtp = 'login/verify';
  static const resendOtp = 'login/resend';
  static const getUpdates = 'login/updates';
  static const getProfile = 'login/profile';
  static const updateProfile = 'login/updateprofile';
  static const updateProfilePhoto = 'login/updateprofilephoto';
  static const getProjects = 'login/projects';
  static const getVehicles = 'login/vehicles';
  static const getHeadquarterVehicles = 'login/headquartervehicles';
  static const createRequest = 'login/newrequest';
  static const updateVehicle = 'login/updatevehicle';
  static const getNotifications = 'login/notifications';
  static const updateNotification = 'login/updatenotification';
  static const attendencelistforapprove = 'approvals/attendance';
  static const updateattendanceapproval = 'approvals/updateattendance';
  static const updatelaborapproval = 'approvals/updatelabor';
  static const approvelaboursattendencelist = 'approvals/labor';
  static const approvelexpenseslist = 'approvals/expense';
  static const updateexpenseapproval = 'approvals/updateexpense';
  static const approvelleaves = 'approvals/leaves';
  static const updateleaveapproval = 'approvals/updateleaves';
  static const approveldprlist = 'approvals/dpr';
  static const updatedprapproval = 'approvals/updatedpr';
  static const approveMachineHireList = 'approvals/machinehirelist';
  static const updateMachineHireApproval = 'approvals/updatemachinehire';
  static const settoken = 'login/settoken';
  static const removetoken = 'login/removetoken';
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
  static const expensescategories = 'masters/expensecategories';

  // Leaves endpoints
  static const createLeave = 'leaves/new';
  static const getLeavesList = 'leaves/list';
  static const leavecategories = 'masters/leavecategories';
  static const requestCategories = 'masters/requestcategory';

  // DPR endpoints
  static const getDprList = 'dpr/list';
  static const getDprDetails = 'dpr/details';
  static const updateDpr = 'dpr/dprupdate';
  static const getMyDprSubmissions = 'dpr/mysubmissions';
  //company assets
  static const companyassets = 'companyassets/list';
  static const assetTransfer = 'companyassets/transfer';
  //inventories
  static const getInventories = 'inventory/list';
  static const inventoryconsumption = 'inventory/transaction';
  static const inventoryTransfer = 'inventory/transfer';
  //multioptionbutton
  static const newattendence = 'attendance/new';
  //employees
  static const employees = 'masters/employees';
  //machine hire
  static const machinehire = 'machineryhire/list';
  //requests
  static const requestList = 'login/requestlist';
  // Cash Balance
  static const cashBalance = 'login/cashbalance';
  static const cashTransactions = 'login/cashtransactions';
  static const createMachineHire = 'machineryhire/new';
  static const machineTypes = 'masters/machinelist';
}
