class ApiManager {
  static const BASE_URL = 'https://axtech.range.ae/api/v2/';
  static const Authorization_token = '3MPHJP0BC63435345341';
  // static const BASE_URL2 = 'https://axtech.range.ae/api/v2/';

  static const Login = 'login?debug=true';
  static const forget = 'forgetPassword?debug=true';
  static const leads = 'leads';
  static const dumpedLeads = 'dumpedLeads';
  static const serviceSatisfactionSurvey = 'serviceSatisfactionSurvey';
  static const closelaed = 'closelaed';
  static const getLead = 'getLead';
  static const interaction = 'getInteraction';
  static const coldCalls = 'coldCalls';
  static const getColdCallByAgent = 'getColdCallByAgent';
  static const getDeviceNotifications = 'getDeviceNotifications';
  static const deleteDeviceNotifications = 'deleteDeviceNotifications';
  static const addComment = 'addLeadComment';
  static const Leadinformation = 'getLead'; //where 29826 is lead id
  static const Leadupdate = 'lead_update'; //where 29826 is lead id
  static const updateColdCallReason =
      'updateColdCallReason'; //where 29826 is lead id
  static const changeColdCallStatus =
      'changeColdCallStatus'; //where 29826 is lead id
  static const coldCallConvetToLead =
      'coldCallConvetToLead'; //where 29826 is lead id
    static const dumpedLeadMovedToActiveLead =
      'dumpedLeadMovedToActiveLead'; //where 29826 is lead id
  static const addLeadActivitySchedule =
      'addLeadActivity'; //where 29826 is lead id
  static const leadSource = 'source';
  static const leadStatus = 'getStatus';
  static const leadShareToAgent = 'leadShareToAgent';
  static const updateProfileInfo = 'updateProfileInfo';
  static const updateProfilePicture = 'updateProfilePicture';
  static const updateAvailabilities = 'updateAvailability';
  static const updatePassword = 'updatePassword?debug=true';
  static const updateLeadActivityHistory = 'updateLeadActivityHistory';
  static const updateLeadActivity = 'updateLeadActivity';
  static const deleteLeadActivity = 'deleteLeadActivity';
  static const singleLeadsAddToCalling = 'singleLeadsAddToCalling';
  static const getLeavesTypes = 'getLeavetypes';
  static const getAllLeaves = 'getAllLeaves';
  static const addLeaveAgent = 'addLeaveAgent';
  static const updateLeaveAgent = 'updateLeaveAgent';
  static const addCallingHistory = 'addCallingHistory';

   static const updateLeadAccept = 'agentAcceptLead';


   static const upadteAdditionalPhone = 'lead_update_additional_phone';

  ///TODO:For Filter
  static const get_developers = 'get_developers';
  static const users = 'users';
  static const getActivityTypes = 'getActivityTypes';
  static const properties = 'properties';
  static const getStatus = 'getStatus';
  static const source = 'source';
  static const get_priorities = 'get_priorities';
  static const coldCallPriorities = 'coldCallPriorities';
  static const getTeamleaders = 'getTeamleaders';

  ///TODO:assign to lead and team leader
  // static const leadShareToAgent = 'leadShareToAgent';

}
