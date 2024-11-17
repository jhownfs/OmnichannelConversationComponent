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
        
        System.assertEquals(listChat, ConversationController.getConversationsByUser(), 'Should return 1 conversation');
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

        System.assertEquals('User is offline, cannot receive workitem', errorMessage);
    }
    

  private static MessagingSession createTestChat(Id userId) {
    MessagingChannel channel = new MessagingChannel();
    channel.MasterLabel = 'Test Channel';
    channel.DeveloperName = 'Test_Channel';
    channel.MessageType = 'Text';
    channel.DeveloperName = 'Test_Channel';
    insert channel;
    
    MessagingEndUser endUser = new MessagingEndUser();
    endUser.Name = 'Test End User';
    endUser.MessagingChannelId = channel.Id;
    endUser.MessageType = 'Text';
    insert endUser;
    
    MessagingSession session = new MessagingSession();
    session.MessagingEndUserId = endUser.Id;
    session.MessagingChannelId = channel.Id;
    session.OwnerId = userId;
    session.Status = 'Ended';
    insert session;
    
    return session;
    }
  }  