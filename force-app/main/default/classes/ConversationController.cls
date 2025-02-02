public without sharing class ConversationController {
   
    @AuraEnabled(cacheable=true)
    public static list<MessagingSession> getConversationsByUser(){
        List<MessagingSession> ConversationsByUser = new List<MessagingSession>();
        try {
            ConversationsByUser = MessaginSessionSelector.getMessagingByUserIdAndWaitingStatus();
            system.debug('ConversationsByUser = ' + ConversationsByUser);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return ConversationsByUser;
    }

    @AuraEnabled
    public static String createPendingServiceRouting(list<MessagingSession> Conversations){

        String msg;

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
            msg = 'sucesso';

        } catch (Exception e) {
            msg = e.getMessage();
            throw new AuraHandledException(e.getMessage());
        }

        return msg;
    }
}