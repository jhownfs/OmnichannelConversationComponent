@isTest
public with sharing class UserFixureFactory {

    public static User createTestUser() {
        
        List<User> Users = [SELECT Id FROM User WHERE Email = 'jdoe@example.com' limit 1];
        
        if(Users == null || Users.isEmpty()){
            Users = new List<User>();
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

            Users.add(user);
        }  
        return Users[0];
    } 
}