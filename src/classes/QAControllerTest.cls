@isTest
public class QAControllerTest {
    @testSetup
    //Create test data from a Utility Test Class
    static void buildTestRecords(){
        QATestDataFactory.createTestData(UserInfo.getUserId(), 10, 2);
    }
    @isTest
    static void testAverageCalc(){
        //Test Calc Average Based on all "Good" QC Notes
        List<Caliber_note__c> aNote = [SELECT training__c, week_number__c, qc_status__c FROM caliber_note__c WHERE note_type__c = 'QC Trainee'];
        String trainingValue = aNote[0].training__c;
        Decimal week = aNote[0].week_number__c;
        String calcAverage = QASummaryController.calculateQAStatus(trainingValue,(Integer)week);
        system.assertEquals('Good', calcAverage);
        
        //Update all notes to Poor, New Calc Average will be "Poor"
        for(Caliber_note__c n : aNote){
            n.qc_status__c = 'Poor';
        }
        update aNote;
        
        calcAverage = QASummaryController.calculateQAStatus(trainingValue,(Integer)week);
        System.assertEquals('Poor', calcAverage);
        
        //Update all notes to Average, New Calc Average will be "Average"
        for(Caliber_note__c n : aNote){
            n.qc_status__c = 'Average';
        }
        update aNote;
        
        calcAverage = QASummaryController.calculateQAStatus(trainingValue,(Integer)week);
        System.assertEquals('Average', calcAverage);
        
        //Update all notes to Superstar, New Calc Average will be "Good"
        for(Caliber_note__c n : aNote){
            n.qc_status__c = 'Superstar';
        }
        update aNote;
        
        calcAverage = QASummaryController.calculateQAStatus(trainingValue,(Integer)week);
        System.assertEquals('Good', calcAverage);
        
        //Test that the method updates the QC value of the batch when sent in a QC_status for the batch
        QASummaryController.updateQABatchRecord(trainingValue, (Integer)week, 'Poor');
        caliber_note__c overallQA = [SELECT qc_status__c FROM caliber_note__c WHERE training__c = :trainingValue AND week_number__c = :week AND note_type__c = 'QC Batch' LIMIT 1];
        System.assertEquals('Poor', overallQA.QC_Status__c);
    }
    @isTest
    //Test that the Methods DML Update is Successful 
    static void testOverallNoteUpdate(){
        //Boolean check that turns false if DML is Unsuccessful
        Boolean dmlSuccess = true;
        Training__c aTraining = [SELECT id FROM Training__C LIMIT 1 ];
        String trainingValue = aTraining.id;
        String note;
        //Try-Catch to catch DML Exceptions
        try{
            note = QASummaryController.updateOverallNotes(trainingValue, 1, 'Test Textbox');
        }catch(DmlException e){
            dmlSuccess = false;
        }
        System.assertEquals('Test Textbox', note);
        System.assert(dmlSuccess);
        
        //Test that initalQANote returns the proper last note
        String returnedNote = QASummaryController.initalQANote(trainingValue, 1);
        System.assertEquals('Test Textbox', note);
    }
    
    @isTest
    //Test the inital loading of the QA Batch Status
    static void testInitalQAStatus(){
        Training__c aTraining = [SELECT id FROM Training__C LIMIT 1 ];
        String trainingValue = aTraining.id;
        //Makes sure that the returned value is 'Good' since the Utility Class sets it as that
        String qaStatus = QASummaryController.initalQAStatus(trainingValue,1);
        System.assertEquals('Good', qaStatus);
        //Deletes the caliber note record to test the DML insert if the record doesn't exist
        Caliber_note__c aNote = [SELECT id FROM Caliber_note__c WHERE week_number__c = 1 AND training__c = :trainingValue AND note_type__c = 'QC Batch'];
        delete aNote;
		String qaUndefined = QASummaryController.initalQAStatus(trainingValue,1);
        //Query to make sure the newly inserted record has a QC status of 'Undefined'
        Caliber_note__c aNewNote = [SELECT id,qc_status__c FROM Caliber_note__c WHERE week_number__c = 1 AND training__c = :trainingValue AND note_type__c = 'QC Batch'];
		System.assertEquals('Undefined', aNewNote.QC_Status__c);        
    }
    
}