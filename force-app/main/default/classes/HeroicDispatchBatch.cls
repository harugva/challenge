public with sharing class HeroicDispatchBatch implements Database.Batchable<sObject> {

    List<Superhero_Mission__c> superheroMissions { get; set; }

    public enum Mode {
        PUBLIC_MISSION, PRIVATE_MISSION
    }

    Mode mode;

    public HeroicDispatchBatch(Mode mode, List<Superhero_Mission__c> superheroMissions) {
        this.mode = mode;
        this.superheroMissions = superheroMissions;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        switch on this.mode {
            when PUBLIC_MISSION {
                return Database.getQueryLocator(
                    'SELECT Id, Name, Contact__c, Contact__r.Email, Guild__c ' + 
                    'FROM Hero__c '
                );
            }
            when PRIVATE_MISSION {
                return Database.getQueryLocator(
                    'SELECT Id, Name, Contact__c, Contact__r.Email, Guild__c ' + 
                    'FROM Hero__c ' +
                    'WHERE Guild__c IN (SELECT Guild__c FROM Superhero_Mission__c WHERE Id IN : superheroMissions)'
                );
            }
            when else {
                return null;            
            }
        }
    }

    public void execute(Database.BatchableContext bc, List<SObject> records) {
        switch on this.mode {
            when PUBLIC_MISSION {
                new HeroicDispatch((List<Hero__c>) records, superheroMissions).sendEmailsWhenPublicMission();
            }
            when PRIVATE_MISSION {
                new HeroicDispatch((List<Hero__c>) records, superheroMissions).sendEmailsWhenPrivateMission();
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
    }
}