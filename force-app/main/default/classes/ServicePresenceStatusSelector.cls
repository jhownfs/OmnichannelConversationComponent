public with sharing class ServicePresenceStatusSelector {
    public static ServiceChannelStatus getPresenceByCurrentUserId(){
        return [SELECT ServiceChannelId 
                FROM ServiceChannelStatus
                WHERE ServicePresenceStatusId IN (SELECT ServicePresenceStatusId
                FROM UserServicePresence
                WHERE IsCurrentState = true 
                AND UserId=:UserInfo.getUserId())
                ];
      }
}