public class AssessmentCreator {
    /* Set the trainerId to a user Id for a user that will be considered a trainer */
    public static Id trainerId = '005f40000044thhAAA';
    // Set the training track to the ID of the 'Salesforce' track
    public static Id trainingTrack = 'a0Cf400000EnYVYEA3';
    public static List <Contact> associates = [SELECT Id FROM Contact WHERE Master_Stage__c = 'Training'];
    
    public static void createAssessmentAndGrades(Id trainingId, String assessmentType){
        
        //create categories for assessments
        List<Caliber_Category__c> cats = new List<Caliber_Category__c>();
        List<String> catNames = new List<String>{'SF Security', 'SF Data Model', 'Sales Cloud', 'Apex', 'Visualforce'};
            for(Integer i = 0; i < 5; i++){
                Caliber_Category__c cat = new Caliber_Category__c();
                cat.Active__c = true;
                cat.Name = catNames[i];
                cats.add(cat);
            }
        insert cats;
        
        //create assessments
        List<Caliber_Assessment__c> assessmentList = new List<Caliber_Assessment__c>();
        for(Integer i = 1; i < 6; i++){
            Caliber_Assessment__c assessment = new Caliber_Assessment__c();
            assessment.Assessment_Type__c = assessmentType;
            assessment.Max_Points__c = 100;
            assessment.Training_Id__c = trainingId;
            assessment.Week_Number__c = i;
            assessment.Assessment_Category__c = cats[i-1].Id;
            assessmentList.add(assessment);
        }
        insert assessmentList;
        
        //create grades for assessments
        List<Caliber_Grade__c> grades = new List<Caliber_Grade__c>();
        ////iterate through assessments
        for(Integer i = 0; i < 5; i++){
            //iterate through associates
            for(Integer j = 0; j < 20; j++){
                Caliber_Grade__c g = new Caliber_Grade__c();
                g.Caliber_Assessment__c = assessmentList[i].Id;
                g.Contact__c = associates[j].Id;
                g.Score__c = (10*i) + 50;
                grades.add(g);
            }
        }
        insert grades;
        
    }//end of createAssessmentAndGrades
   
    public static void createBatch(String startDate, String endDate){
        Training__c batch = new Training__c();
        batch.StartDate__c = Date.parse(startDate);
        batch.EndDate__c = Date.parse(endDate);
        batch.Status__c = 'In Progress';
        batch.Trainer__c = trainerId;
        batch.TrainingTrack__c = trainingTrack;
        insert batch;
    }
    
    public static void createTrainingAssignments(Id batchId){
        List<Training_Assignment__c> taList = new List<Training_Assignment__c>();
        for(Integer i = 0; i < 20; i++){
            Training_Assignment__c ta = new Training_Assignment__c();
            ta.Contact__c = associates[i].Id;
            ta.Training__c = batchId;
            ta.Name = 'TA-00' + (i + 20);
            taList.add(ta);
        }
        insert taList;
    }
}