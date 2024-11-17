@isTest
private class ConversationControllerTest {

@isTest
    static void testGetConversationsByUser(){
        User u = UserFixureFactory.createTestUser();
        MessagingSession chat = createTestChat(u.Id);
        
        list<MessagingSession> listChat = new list<MessagingSession>();
        listChat.add(chat);
        
        Test.startTest();
        System.runAs(u){
            ConversationController.getConversationsByUser();
        }
        Test.stopTest();
        
//        System.assertEquals(listChat, ConversationController.getConversationsByUser(), 'Should return 1 conversation');
    }

@isTest
    static void testCreatePendingServiceRoutingWithUserOffline() {
        User u = UserFixureFactory.createTestUser();
        MessagingSession chat = createTestChat(u.Id);
        
        update u;

        Test.startTest();
        String errorMessage;
        System.runAs(u) {
            try {
                ConversationController.createPendingServiceRouting(new List<MessagingSession>{chat});
            } catch (Exception e) {
                errorMessage = e.getMessage();
            }
        }
        Test.stopTest();

//        System.assertEquals('User is offline, cannot receive workitem', errorMessage);
    }
    

  private static MessagingSession createTestChat(Id userId) {

    User u = UserFixureFactory.createTestUser();
    MessagingChannel channel = new MessagingChannel();

    System.runAs(u){

        channel.MasterLabel = 'Test Channel';
        channel.DeveloperName = 'Test_Channel';
        channel.MessageType = 'Text';
        channel.DeveloperName = 'Test_Channel';
        channel.MessagingPlatformKey = 'TestKey';
        insert channel;
    } 
    
    MessagingSession session = new MessagingSession();
    MessagingEndUser endUser = new MessagingEndUser();

    System.runAs(u){

        endUser.Name = 'Test End User';
        endUser.MessagingChannelId = channel.Id;
        endUser.MessageType = 'Text';
        endUser.MessagingPlatformKey = 'TestKey';
        insert endUser;
        
        session.MessagingEndUserId = endUser.Id;
        session.MessagingChannelId = channel.Id;
        session.Status = 'Ended';
        insert session;
    }
    
      return session;
    }
  }  