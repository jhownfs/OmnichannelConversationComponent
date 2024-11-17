@isTest
public with sharing class UserFixureFactory {

    public static User createTestUser() {
        
        User user = new User();
  
        user.FirstName = 'John';
        user.LastName = 'Doe';
        user.Alias = 'jdoe';
        user.Email = 'jdoe@example.com';
        user.Username = 'jdoe@example.com';
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user.UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'CEO'].Id;
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.TimeZoneSidKey = 'America/Los_Angeles';
  
        return user;
    } 
}