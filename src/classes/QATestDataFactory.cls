@isTest
public class QATestDataFactory {
    public static void createTestData(String trainerId, Integer numAssociates, Integer numBatches){
        // Create associates
        List<Contact> associates = new List<Contact>();
        for(Integer i = 0; i < numAssociates; i++){
            Contact a = new Contact();
            a.Email = 'batch' + 'trainee' + i + '@test.com';
            a.Master_Stage__c = 'Training';
            a.FirstName = 'batch';
            a.LastName = 'trainee ' + i;
            associates.add(a);
        }
        insert associates;
        
        //create Training_Track
        Training_Track__c track = new Training_Track__c();
        track.Active__c = true;
        track.ShortName__c = 'Salesforce';
        track.Name = 'Salesforce';
        insert track; 
        
        Date startDate = Date.parse('09/03/2018');
        Date endDate = Date.parse('11/16/2018');
        
        List<Training__c> batches = new List<Training__c>();
        for(Integer i = 1; i <= numBatches; i++){
            Training__c batch = new Training__c();
            batch.StartDate__c = startDate.addDays(7*i);
            batch.EndDate__c = endDate.addDays(7*i);
            batch.Status__c = 'In Progress';
            batch.Trainer__c = trainerId;
            batch.TrainingTrack__c = track.Id;
            batches.add(batch);
        }
        
        insert batches;
        
        //Create Training Assignments
        List<Training_Assignment__c> taList = new List<Training_Assignment__c>();
        for(Training__c batch : batches){
            for(Integer i = 0; i < numAssociates; i++){
                Training_Assignment__c ta = new Training_Assignment__c();
                ta.Contact__c = associates[i].Id;
                ta.Training__c = batch.Id;
                ta.Name = 'TA-' + i;
                taList.add(ta);
            }
        }
        insert taList;
        
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
        
        List<String> assessmentTypes = new List<String>{'Exam', 'Verbal', 'Project'};
        List<Caliber_Assessment__c> assessmentList = new List<Caliber_Assessment__c>();
        
        // For each batch, create three assessments for five weeks worth of data.
        for(Training__c batch : batches){
            for(String assessmentType : assessmentTypes){
                for(Integer i = 1; i < 6; i++){
                    Caliber_Assessment__c assessment = new Caliber_Assessment__c();
                    assessment.Assessment_Type__c = assessmentType;
                    assessment.Max_Points__c = 100;
                    assessment.Training_Id__c = batch.Id;
                    assessment.Week_Number__c = i;
                    assessment.Assessment_Category__c = cats[i-1].Id;
                    assessmentList.add(assessment);
                }
            }
        }
        insert assessmentList;
        
        //create grades for assessments
        List<Caliber_Grade__c> grades = new List<Caliber_Grade__c>();
        //iterate through assessments
        for(Integer i = 0; i < 15; i++){
            //iterate through associates
            for(Integer j = 0; j < numAssociates; j++){
                Caliber_Grade__c g = new Caliber_Grade__c();
                g.Caliber_Assessment__c = assessmentList[i].Id;
                g.Contact__c = associates[j].Id;
                g.Score__c = 70 + (2*i);
                grades.add(g);
            }
        }
        insert grades;
        
        // create caliber notes
        List<Caliber_Note__c> qcList = new List<Caliber_Note__c>();
        for(Training__c batch : batches){
            // iterate through weeks
            for (Integer i = 1; i < 6; i++){
                Caliber_Note__c batchQC = new Caliber_Note__c();
                batchQC.Is_QC_Feedback__c = true;
                batchQC.Note_Type__c = 'QC Batch';
                batchQC.QC_Status__c = 'Good';
                batchQC.Training__c = batch.Id;
                batchQC.Week_Number__c = i;
                batchQC.Note_Content__c = 'good job on week ' + i;
                qcList.add(batchQC);
                //iterate through associates
                for (Integer j = 0; j < numAssociates; j++){
                    Caliber_Note__c associateQC = new Caliber_Note__c();
                    associateQC.Contact__c = associates[j].Id;
                    associateQC.Is_QC_Feedback__c = true;
                    associateQC.Note_Type__c = 'QC Trainee';
                    associateQC.QC_Status__c = 'Good';
                    associateQC.Training__c = batch.Id;
                    associateQC.Week_Number__c = i;
                    associateQC.Note_Content__c = 'good job on week ' + i;
                    qcList.add(associateQC);
                }
            }
        }
       insert qcList;
    }
}