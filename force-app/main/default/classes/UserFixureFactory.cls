@isTest
public with sharing class UserFixureFactory {

    public static User createTestUser() {
        
      String uniqueUsername = 'testuser' + System.currentTimeMillis() + '@example.com';

      User u = new User(
          FirstName = 'Test',
          LastName = 'User',
          Alias = 'tuser',
          Email = 'test@example.com',
          Username = uniqueUsername,
          ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
          TimeZoneSidKey = 'America/Los_Angeles',
          LocaleSidKey = 'en_US',
          EmailEncodingKey = 'UTF-8',
          LanguageLocaleKey = 'en_US'
      );
      insert u;
      return u;
    } 
}