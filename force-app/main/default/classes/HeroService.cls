public with sharing class HeroService {
    public static void beforeInsert(List<Hero__c> newHeroes) {
        checkRelatedContact(newHeroes);
    }

    public static void beforeUpdate(List<Hero__c> newHeroes, Map<Id, Hero__c> oldHeroesByIds) {
        checkRelatedContactBeforeUpdate(newHeroes, oldHeroesByIds);
    }

    private static void checkRelatedContactBeforeUpdate(List<Hero__c> newHeroes, Map<Id, Hero__c> oldHeroesByIds) {
        List<Hero__c> heroesWithModifiedFields = (List<Hero__c>) Utils.getModifiedRecords(new List<String>{ 'Contact__c' }, newHeroes, oldHeroesByIds);
        if (heroesWithModifiedFields != null && !heroesWithModifiedFields.isEmpty()) {
            checkRelatedContact(heroesWithModifiedFields);
        }
    }

    private static void checkRelatedContact(List<Hero__c> heroes) {
        Set<Id> relatedContactIds = Utils.getRelatedIds(heroes, 'Contact__c');

        List<User> relatedUsers = [SELECT ContactId FROM User WHERE ContactId IN : relatedContactIds];

        Set<Id> existentPairsIds = Utils.getRelatedIds(relatedUsers, 'ContactId');

        for (Hero__c hero : heroes) {
            if (!existentPairsIds.contains(hero.Contact__c)) {
                hero.addError('Contact__c', 'Related Contact must be a Portal User.');
            }
        }
    }
}