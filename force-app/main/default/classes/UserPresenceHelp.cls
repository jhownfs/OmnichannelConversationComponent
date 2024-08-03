public with sharing class UserPresenceHelp {
    
    public static boolean canIcreatePendingServiceToUser(){
       return (!ServicePresenceStatusSelector.getPresenceByCurrentUserId().isEmpty());
    }
}