public class QATraineeRowController {
	@AuraEnabled
    public static String GetTraineeID(Training_Assignment__c Training_Assignment)
    {	//System.debug('oi! inside the getTraineeInfo apex controller. Id:'+Training_Assignment.id);
        String str = Training_Assignment.id;
       //return [SELECT Id, Name, Contact__r.FirstName, Contact__r.LastName FROM Training_Assignment__c 
       //         WHERE Id = :Training_Assignment.id LIMIT 1];
       return str;         
    }
	@AuraEnabled
    public static Training_Assignment__c GetTraineeInfo(Training_Assignment__c Training_Assignment)
    {	//Apparently, when Training_Assignment is passed into QATraineeRow, the names of the contact are not attached
        //So this goes and fetches the missing fields and overwrites the attribute
       return [SELECT Id, Name, Contact__r.FirstName, Contact__r.LastName, Contact__r.Id FROM Training_Assignment__c 
               WHERE Id = :Training_Assignment.id LIMIT 1];                
    }            
    /* original@AuraEnabled
    public static Caliber_Note__c getCaliberNote(Training_Assignment__c Training_Assignment, Integer Week_Number)
    {
        //Training_Assignment__c assignment = [SELECT Id, Contact__r.Id FROM Training_Assignment__c
          //            						 WHERE Id = :Training_Assignment_Id];
        System.debug('Inside getCaliberNote, Contact Name is: '+Training_Assignment.Contact__r.FirstName);
        Id Trainee_Id = Training_Assignment.Contact__c;
        //System.debug('getCaliberNote id= ' + Trainee_Id);
        return [SELECT QC_Status__c, Note_Content__c FROM Caliber_Note__c 
                WHERE (Contact__c = :Trainee_Id AND Note_Type__c = 'QC Trainee' AND Week_Number__c=: Week_Number)];
        /*Caliber_Note__c cn = [SELECT QC_Status__c, Note_Content__c FROM Caliber_Note__c 
        			          WHERE (Contact__c = :Trainee_Id AND Week_Number__c=: Week_Number)];  
        System.debug('cn='+cn);
        return cn; 
    } */
@AuraEnabled
    public static Caliber_Note__c getCaliberNote(Training_Assignment__c Training_Assignment, Integer Week_Number)
    {
        //Training_Assignment__c assignment = [SELECT Id, Contact__r.Id FROM Training_Assignment__c
          //            						 WHERE Id = :Training_Assignment_Id];
        System.debug('Inside getCaliberNote, Contact Name is: '+Training_Assignment.Contact__r.FirstName);
        Id Trainee_Id = Training_Assignment.Contact__c;
        //System.debug('getCaliberNote id= ' + Trainee_Id);
        Integer n = [SELECT COUNT() FROM Caliber_Note__c 
                WHERE (Contact__c = :Trainee_Id AND Note_Type__c = 'QC Trainee' AND Week_Number__c=: Week_Number)];
        	System.debug('n='+n);
        if (n>0){
            // if a note was found, return it
            Caliber_Note__c cn = [SELECT QC_Status__c, Note_Content__c FROM Caliber_Note__c 
                    WHERE (Contact__c = :Trainee_Id AND Note_Type__c = 'QC Trainee' AND Week_Number__c=: Week_Number)];             
            System.debug('cn='+cn);
            return cn; 
        } 
        else{
            // no note records for that trainee for that week were found
            // create a new blank note, insert it, and then return it
            Caliber_Note__c cn = new Caliber_Note__c();
            cn.Contact__c=Trainee_Id;
            cn.Week_Number__c=Week_Number;
            cn.Is_QC_Feedback__c=false;
            cn.Note_Content__c='';
            cn.Note_Type__c='QC Trainee';
            List<Contact> c = [SELECT (SELECT ID FROM Training_Assignments__r LIMIT 1) FROM Contact WHERE ID=:Trainee_Id LIMIT 1];
            Training_Assignment__c trass = c[0].Training_Assignments__r[0];
            List<Training_Assignment__c> trassList = [SELECT Training__c FROM Training_Assignment__c WHERE ID=:trass.ID LIMIT 1];
            cn.Training__c=trassList[0].Training__c;
            insert cn;
             System.debug('cn='+cn);
            return cn;
        }
    }

    @AuraEnabled
    public static void SaveTraineeNote(Training_Assignment__c Training_Assignment, String Note, Integer Week_Number)
    {
        //Training_Assignment__c assignment = [SELECT Id, Contact__r.Id FROM Training_Assignment__c
                      	//					 WHERE Id = :Training_Assignment_Id];
        Id Trainee_Id = Training_Assignment.Contact__c;
        System.debug('SaveTraineeNote id= ' + Trainee_Id);
        Caliber_Note__c trainee_info = [SELECT Id, Note_Content__c, Week_Number__c FROM Caliber_Note__c 
                                        WHERE Contact__c = :Trainee_Id AND Week_Number__c = :Week_Number AND Note_Type__c = 'QC Trainee'];
        
	        trainee_info.Note_Content__c = Note;
        	update trainee_info;
   	}
    
    @AuraEnabled
    public static void SaveTraineeQC(Training_Assignment__c Training_Assignment, String Assessment, Integer Week_Number)
    {
        //Training_Assignment__c assignment = [SELECT Id, Contact__r.Id FROM Training_Assignment__c
                               //              WHERE Id = :Training_Assignment_Id];
        Id Trainee_Id = Training_Assignment.Contact__c;
        System.debug('SaveTraineeQC id= ' + Trainee_Id);
        Caliber_Note__c trainee_info = [SELECT Id, QC_Status__c, Week_Number__c  FROM Caliber_Note__c
                                         WHERE Contact__c = :Trainee_Id AND Week_Number__c = :Week_Number AND Note_Type__c = 'QC Trainee'];
        trainee_info.QC_Status__c = Assessment;
        update trainee_info;
    }
}