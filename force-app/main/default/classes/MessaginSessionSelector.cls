public without sharing class MessaginSessionSelector {
   
    public static List<MessagingSession> getMessagingByUserIdAndWaitingStatus(){
      return [SELECT Id, Status, MessagingChannelId, Lead.FirstName, Lead.LastName, EndUserAccount.Name, EndUserContact.FirstName, EndUserContact.LastName
              FROM MessagingSession 
              WHERE OwnerId = :UserInfo.getUserId()
              AND (Status = 'Waiting' or Status = 'Inactive')
              ];
    }
}