@isTest
public class CategoriesCoveredControllerTest {
    @isTest
    public static void testGetCategories()
    {
        //create one training
        Training__c training = new Training__c(Caliber_Number_Of_Weeks__c=1);
        insert training;
        //insert two caliber categories with different names
        Caliber_Category__c soql = new Caliber_Category__c(Name='SOQL');
        Caliber_Category__c sosl = new Caliber_Category__c(Name='SOSL');
        insert soql;
        insert sosl;
        //create one caliber assessment
        Caliber_Assessment__c caliber_assessment_soql = new Caliber_Assessment__c(Training_Id__c=training.Id, Week_Number__c=1, Max_Points__c=50, Assessment_Type__c='Verbal', Assessment_Category__c=soql.Id);
        Caliber_Assessment__c caliber_assessment_sosl = new Caliber_Assessment__c(Training_Id__c=training.Id, Week_Number__c=1, Max_Points__c=50, Assessment_Type__c='Verbal', Assessment_Category__c=sosl.Id);
        insert caliber_assessment_soql;
        insert caliber_assessment_sosl;
        //Call the apex function.
        String result = QACategoriesCoveredController.getCategories(training.Id, 1);
        //Assert that the resulting string was created and returned successfully.
        System.assertEquals('SOQL, SOSL', result);
        String result2 = QACategoriesCoveredController.getCategories(null, 1);
        //Assert that the resulting string was created and returned successfully.
        System.assertEquals('', result2);
    }
}