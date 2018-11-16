@isTest
public class QATraineeRowControllerTest {    
    
    //A set of records needs to be created in each test method instead of in testSetup
    //so that the ids of each record can be accessed inside of the test functions,
    //since the apex controller functions require them as parameters.
    
    @isTest
    public static void testGetTraineeInfo()
    {   
        //Create a trainee record.
        Contact trainee = new Contact(FirstName='Test', LastName='Trainee');
        insert trainee;
        //Create a training record.
        Training__c training = new Training__c(Caliber_Number_Of_Weeks__c=1);
        insert training;
        //Create a Trainging Assignment record to link the above two records
        Training_Assignment__c training_assignment = new Training_Assignment__c(Contact__c=trainee.Id, Training__c=training.Id, Name='Test Training Assignment');
        insert training_assignment;
        //Create a Caliber Note record with the training and trainee ids and week number set to 1
        Caliber_Note__c caliber_note = new Caliber_Note__c(Training__c=training.Id, Contact__c=trainee.Id, QC_Status__c='Undefined', Week_Number__c=1);
        insert caliber_note;
        //Call the apex function.
        Training_Assignment__c ta = QATraineeRowController.getTraineeInfo(training_assignment);
        //Create a string to hold the id of the training assignment
        String testTrainingID = QATraineeRowController.GetTraineeID(training_assignment);
        
		//Assert that the training assessment was returned successfully, 
		//and that the name of the associated trainee is correct.
		System.assertEquals('Test Training Assignment', ta.Name);
        System.assertEquals('Test', ta.Contact__r.FirstName);
        System.assertEquals('Trainee', ta.Contact__r.LastName);
        System.assertEquals(training_assignment.id, testTrainingID);
    }
    
    @isTest
    public static void testGetNote()
    {
        //Create a trainee record.
        Contact trainee = new Contact(FirstName='Test', LastName='Trainee');
        insert trainee;
        //Create a training record.
        Training__c training = new Training__c(Caliber_Number_Of_Weeks__c=1);
        insert training;
        //Create a Trainging Assignment record to link the above two records
        Training_Assignment__c training_assignment = new Training_Assignment__c(Contact__c=trainee.Id, Training__c=training.Id, Name='Test Training Assignment');
        insert training_assignment;
        //Create a Caliber Note record with the training and trainee ids and week number set to 1
        Caliber_Note__c caliber_note = new Caliber_Note__c(Training__c=training.Id, Contact__c=trainee.Id, QC_Status__c='Undefined', Note_Type__c='QC Trainee', Note_Content__c='Test Content', Week_Number__c=1);
        insert caliber_note;
        //Call the apex function.
        Caliber_Note__c cn = QATraineeRowController.getCaliberNote(training_assignment, 1);
        //Assert that the caliber note and its information was retrieved successfully.
        System.assertEquals(caliber_note.Id, cn.Id);
        System.assertEquals('Test Content', cn.Note_Content__c);
        System.assertEquals('Undefined', cn.QC_Status__c);
    }
    
    @isTest
    public static void testSaveNote()
    {
        //Create a Trainee record
        Contact trainee = new Contact(FirstName='Test', LastName='Trainee');
        insert trainee;
        //Create a Training record
        Training__c training = new Training__c(Caliber_Number_Of_Weeks__c=1);
        insert training;
        //Create a Trainging Assignment record to link the above two records
        Training_Assignment__c training_assignment = new Training_Assignment__c(Contact__c=trainee.Id, Training__c=training.Id, Name='Test Training Assignment');
        insert training_assignment;
        //Create a Caliber Note record with the training and trainee ids and week number set to 1
        Caliber_Note__c caliber_note = new Caliber_Note__c(Training__c=training.Id, Contact__c=trainee.Id, QC_Status__c='Undefined', Week_Number__c=1, Note_Content__c='Default');
        insert caliber_note;
        //Call the apex function.
        QATraineeRowController.SaveTraineeNote(training_assignment, 'Test Note', 1);
        //Retrieve caliber note record from the database.
        caliber_note = [SELECT Id, Note_Content__c FROM Caliber_Note__c WHERE Id = :caliber_note.Id];
        //Assert that the change was made successfully.
        System.assertEquals('Test Note', caliber_note.Note_Content__c);
    }
    
    @isTest
    public static void testSaveQC()
    {
        //Create a Trainee record
        Contact trainee = new Contact(FirstName='Test', LastName='Trainee');
        insert trainee;
        //Create a Training record
        Training__c training = new Training__c(Caliber_Number_Of_Weeks__c=1);
        insert training;
        //Create a Trainging Assignment record to link the above two records
        Training_Assignment__c training_assignment = new Training_Assignment__c(Contact__c=trainee.Id, Training__c=training.Id, Name='Test Training Assignment');
        insert training_assignment;
        //Create a Caliber Note record with the training and trainee ids and week number set to 1
        Caliber_Note__c caliber_note = new Caliber_Note__c(Training__c=training.Id, Contact__c=trainee.Id, QC_Status__c='Undefined', Week_Number__c=1, Note_Content__c='Default');
        insert caliber_note;
        //Call the apex function
        QATraineeRowController.SaveTraineeQC(training_assignment, 'Average', 1);
        //Retrieve caliber note record from the database.
        caliber_note = [SELECT Id, QC_Status__c FROM Caliber_Note__c WHERE Id = :caliber_note.Id];
        //Assert that the change was made successfully.
        System.assertEquals('Average', caliber_note.QC_Status__c);
    }
}