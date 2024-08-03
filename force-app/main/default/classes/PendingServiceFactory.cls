public with sharing class PendingServiceFactory {

    private static List<PendingServiceRouting> PendingServices = new List<PendingServiceRouting>();

    public static void createPendingServinceRoutingforCurrentUser(list<SObject> workItems){
        
        for(SObject obj: workItems){
            PendingServiceRouting psrObj = new PendingServiceRouting();
            psrObj.CapacityWeight = 1;
            psrObj.IsReadyForRouting = true;
            psrObj.ServiceChannelId = ServicePresenceStatusSelector.getPresenceByCurrentUserId()[0].ServiceChannelId;
            psrObj.WorkItemId = obj.Id;
            psrObj.RoutingType = 'SkillsBased';
            psrObj.RoutingPriority = 1;
            psrObj.PreferredUserId = UserInfo.getUserId();
            psrObj.IsPreferredUserRequired = true;
            PendingServices.add(psrObj);
        }
    }

    public static list<PendingServiceRouting> getPendingServinceRouting(){
      return PendingServices;
    }
}