public with sharing class ServicePresenceStatusSelector {
    public static List<ServiceChannelStatus> getPresenceByCurrentUserId(){

        List<Id> ServiceChannelUser = new List<Id>();

       for(UserServicePresence userService : [SELECT ServicePresenceStatusId
                                              FROM UserServicePresence
                                              WHERE IsCurrentState = true 
                                              AND UserId=:UserInfo.getUserId()]){
           ServiceChannelUser.add(userService.ServicePresenceStatusId);
         }

       List<ServiceChannelStatus> ServiceChannelStatus = [SELECT ServiceChannelId 
                FROM ServiceChannelStatus
                WHERE ServicePresenceStatusId IN : ServiceChannelUser
                ];
                
        return ServiceChannelStatus;
      }
}