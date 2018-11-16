public class QABatchTableController {
	/* This controller is the 'workhorse' of the WeekTabMenu component */
    @AuraEnabled
    public static Training__c getCurrentBatch(){
        return [SELECT id, Name, Caliber_Number_of_Weeks__c FROM Training__c LIMIT 1];
    }

    @AuraEnabled
    public static String getCurrentBatchID(){
        Training__c batch = [SELECT id, Name, Caliber_Number_of_Weeks__c FROM Training__c LIMIT 1];
        String str = batch.id;
        System.debug('Hello from getCurrentBatchId on btcapx!! batch is: '+ batch);
        System.debug('and id is: '+ str);
        return str;
    }
    
    @AuraEnabled
    public static Training__c incrementWeek(Training__c batch){
        batch.Caliber_Number_of_Weeks__c++;
        update batch;
        
        // after updating the number of weeks on the Training__c, it should also create blank
        // Caliber_Note__c for each of the trainees enrolled in that batch for that new week.
        
        List<Caliber_Note__c> qcList = new List<Caliber_Note__c>(); 
        // empty list for the soon to be created blank caliber notes
        
        List<Training_Assignment__c> tac = new List<Training_Assignment__c>();
        // grabs all of the training assignments (aka, the assigned trainees) for the batch
        tac = [SELECT Contact__c FROM Training_Assignment__c WHERE Training__c =: batch.Id];
        
        // for each trainee, make a new blank caliber note for the newly created week
        for(Training_Assignment__c ta: tac){
            Caliber_Note__c b = new Caliber_Note__c();
            b.Is_QC_Feedback__c = true;
            b.Note_Type__c = 'QC Trainee';
            b.QC_Status__c = 'Undefined';
            b.Contact__c = ta.Contact__c;
            b.Training__c = batch.Id;
            b.Week_Number__c = batch.Caliber_Number_of_Weeks__c;            
			qcList.add(b);
        }
        insert qcList;
        return batch;
    }
    
    /*  DECRICATED
    @AuraEnabled
    public static List<Contact> getAssociates(ID batchID){
        List<Training_Assignment__c> trainAss = [SELECT ID, Contact__c FROM Training_Assignment__c WHERE Training__c=:batchID];
        List<Contact> allCons = [SELECT Name FROM Contact];
        List<Contact> batchCons = new List<Contact>();
        for(Contact c : allCons){
            for(Training_Assignment__c ta : trainAss){
                if(ta.Contact__c == c.ID){
                    batchCons.add(c);
                    break;
                }
            }
        }        
        return batchCons;
    }*/
    
    @AuraEnabled
    public static List<Training_Assignment__c> getAssociates(String batchID){
        System.debug('is the problem here? ID is '+ batchID);
        List<Training_Assignment__c> trainAss = [SELECT ID, Contact__c FROM Training_Assignment__c WHERE Training__c= :batchID];
        System.debug(trainAss);
        return trainAss;
    }
    
    @AuraEnabled
    public static Caliber_Note__c getNote(Decimal week, ID associate){
        System.debug(week);
        System.debug(associate);
        for(Caliber_Note__c n : [SELECT ID, Note_Content__c, Contact__c, Week_Number__c FROM Caliber_Note__c]){
            if(n.Week_Number__c==week&&n.Contact__c==associate){
                System.debug('poop');
                return n;
            }
        }
        Caliber_Note__c n = new Caliber_Note__c();
        n.Contact__c=associate;
        n.Week_Number__c=week;
        n.Is_QC_Feedback__c=false;
        n.Note_Content__c='';
        n.Note_Type__c='Trainee';
        List<Contact> c = [SELECT (SELECT ID FROM Training_Assignments__r LIMIT 1) FROM Contact WHERE ID=:associate LIMIT 1];
        Training_Assignment__c trass = c[0].Training_Assignments__r[0];
        List<Training_Assignment__c> trassList = [SELECT Training__c FROM Training_Assignment__c WHERE ID=:trass.ID LIMIT 1];
        n.Training__c=trassList[0].Training__c;
        insert n;
        return n;
    }
    
    @AuraEnabled
    public static Caliber_Note__c saveNote(Caliber_Note__c note){
        update note;
        return note;
    }
    
    
}