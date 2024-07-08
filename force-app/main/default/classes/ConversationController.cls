public without sharing class ConversationController {
   
    @AuraEnabled(cacheable=true)
    public static list<MessagingSession> getConversationsByUser(){
        List<MessagingSession> lstConversationsByUser = new List<MessagingSession>();
        try {
            lstConversationsByUser = MessaginSessionSelector.getMessagingByUserIdAndWaitingStatus();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return lstConversationsByUser;
    }

    @AuraEnabled
    public static string createPendingServiceRouting(list<MessagingSession> lstConversatios){
        String msg;
        try {
            List<PendingServiceRouting> lstPSD = new List<PendingServiceRouting>();
            for(MessagingSession conversation: lstConversatios){
                PendingServiceRouting psrObj = new PendingServiceRouting();
                psrObj.CapacityWeight = 1;
                psrObj.IsReadyForRouting = true;
                psrObj.ServiceChannelId = ServicePresenceStatusSelector.getPresenceByCurrentUserId().ServicePresenceStatusId;
                psrObj.WorkItemId = conversation.Id;
                psrObj.RoutingType = 'SkillsBased';
                psrObj.RoutingPriority = 1;
                psrObj.PreferredUserId = UserInfo.getUserId();
                psrObj.IsPreferredUserRequired = true;
                lstPSD.add(psrObj);
            }

            Database.SaveResult[] result = Database.insert(lstPSD, false);
   
            for(Database.SaveResult resultObj : result){
                if(!resultObj.isSuccess()){
                    for(Database.Error err : resultObj.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
            msg = 'sucesso';

        } catch (Exception e) {
            msg = e.getMessage();
            throw new AuraHandledException(e.getMessage());
        }

        return msg;
    }
}