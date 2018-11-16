@isTest
public class TestQABatchCont {

    @testSetup
    //Creates Test Data From TestDataFactory Class
    static void createTestData(){
        QATestDataFactory.createTestData(UserInfo.getUserId(), 2 , 10);
    }
    
    @isTest
    static void qaBatchTest(){
        //Test getCurrentBatch() to make sure it doesn't return null
        Training__C aTraining = QABatchTableController.getCurrentBatch();
        System.assertNotEquals(null, aTraining);
        
        //Test getCurrentBatchID to make sure it returns an ID for a Training__c object
        String aTrainingId = QABatchTableController.getCurrentBatchID();
        System.assertNotEquals(null, aTraining);
        //Makes sure returns non-null value
        Training__c returnedTraining = QABatchTableController.incrementWeek(aTraining);
        System.assertNotEquals(null,returnedTraining);
        //Makes sure the methods increments the record from an update
        Training__c updatedTraining = [SELECT id, caliber_number_of_weeks__c,(SELECT id FROM Caliber_Notes__r) FROM Training__c WHERE id = :aTraining.id];
        System.assertEquals(aTraining.Caliber_Number_of_Weeks__c, updatedTraining.Caliber_Number_of_Weeks__c);
        //Makes sure that the method creates new records for the associated caliber_note__c object
        System.assertNotEquals(0,updatedTraining.caliber_notes__r.size());
        
        //Test that the method returns a non-empty list
        List<Training_Assignment__c> taList = QABatchTableController.getAssociates(aTrainingId);
        System.assertNotEquals(0, taList.size());
        
        Contact trainee = new Contact(FirstName='Test', LastName='Trainee');
        insert trainee;
        Contact queriedTrainee = [SELECT id FROM Contact WHERE FirstName = 'Test' AND LastName='Trainee'];
        taList[0].contact__c = queriedTrainee.id;
        update taList;
		//Makes sure that new notes where created for that contact
        Caliber_Note__c aNote = QABatchTableController.getNote(1, queriedTrainee.id);
        System.assertNotEquals(null, aNote);
        //Makes sure no new note was created if it exist
        Integer dmlStatements  = Limits.getDmlStatements();
        Caliber_Note__c validNote = QABatchTableController.getNote(1, queriedTrainee.id);
        System.assertEquals(dmlStatements, Limits.getDmlStatements());
        System.assertNotEquals(null,validNote);
        
        //Makes sure DML statement was successful
        Boolean isSuccessfulDml = true;
        try{
             QABatchTableController.saveNote(validNote);
        }catch(DmlException e){
            isSuccessfulDml = false;
        }
        System.assert(isSuccessfulDml);
    }
    
    /*@isTest
    static void testNotes(){
        Training__C aTraining = QABatchTableController.getCurrentBatch();
        List<Training_Assignment__c> taList = QABatchTableController.getAssociates(aTraining.id);
        Caliber_Note__c aNote = QABatchTableController.getNote(1, taList[0].id);
        System.assertNotEquals(null, aNote);
            
    }*/
}