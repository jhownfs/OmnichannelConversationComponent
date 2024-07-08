public with sharing class ServicePresenceStatusSelector {
    public static UserServicePresence getPresenceByCurrentUserId(){
        return [SELECT Id, ServicePresenceStatusId
                FROM UserServicePresence
                WHERE IsCurrentState = true 
                AND UserId=:UserInfo.getUserId()
                ];
      }
}