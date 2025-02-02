public with sharing class UserPresenceHelper {
    public static boolean canIcreatePendingServiceToUser(){
        return (!ServicePresenceStatusSelector.getPresenceByCurrentUserId().isEmpty());
     }
}