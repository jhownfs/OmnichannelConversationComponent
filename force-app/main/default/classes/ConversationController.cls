public without sharing class ConversationController {
   
    @AuraEnabled(cacheable=true)
    public static list<MessagingSession> getConversationsByUser(){
        List<MessagingSession> ConversationsByUser = new List<MessagingSession>();
        try {
            ConversationsByUser = MessaginSessionSelector.getMessagingByUserIdAndWaitingStatus();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return ConversationsByUser;
    }

    @AuraEnabled
    public static boolean createPendingServiceRouting(list<MessagingSession> Conversations){

        boolean saved;

        try {

            if(!UserPresenceHelper.canIcreatePendingServiceToUser()){
                throw new UsarPresenceException('User is offline, cannot receive workitem');
            }

            PendingServiceFactory.createPendingServinceRoutingforCurrentUser(Conversations);
            List<PendingServiceRouting> PendingServices = PendingServiceFactory.getPendingServinceRouting();

            Database.SaveResult[] result = Database.insert(PendingServices, false);
   
            for(Database.SaveResult resultObj : result){
                if(!resultObj.isSuccess()){
                    for(Database.Error err : resultObj.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
            saved = true;

        } catch (Exception e) {
            saved = false;
            throw new AuraHandledException(e.getMessage());
        }

        return saved;
    }
}