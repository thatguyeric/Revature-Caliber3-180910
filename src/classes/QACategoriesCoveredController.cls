public class QACategoriesCoveredController {
	@AuraEnabled
    public static String getCategories(String myTrainingID, Integer Week_Number)
    {	// Training_Id is not being received over here 
        List<Caliber_Category__c> categories = new List<Caliber_Category__c>();
        List<Caliber_Assessment__c> calAssessments = new List<Caliber_Assessment__c>();
        List<Id> categoriesId = new List<Id>();
        
        String category_names = '';
        Boolean first_pass = true;        
        System.debug('training id: ' + myTrainingID + '  week: '+ Week_Number);
        calAssessments = [SELECT Id, Assessment_Category__c FROM Caliber_Assessment__c
              WHERE (Training_Id__c =:myTrainingID AND Week_Number__c =:Week_Number)];
        System.debug('caliber assessments: '+ calAssessments);               
        
        for(Caliber_Assessment__c calAssessment : calAssessments){
            categoriesId.add(calAssessment.Assessment_Category__c);
        }
        categories = [SELECT Name FROM Caliber_Category__c WHERE Id IN:categoriesId];
        System.debug('categories: ' + categories);
        
     	Set<String> caliberCategoryNames = new Set<String>();
        
        for(Caliber_Category__c cc : categories){
            caliberCategoryNames.add(cc.Name);
        }
        
        for(String ccName : caliberCategoryNames)
        {
            if(first_pass)
            {
            	category_names = ccName;
                first_pass = false;
            }
            else
            {
                category_names += ', ' + ccName;
            }
        }
        return category_names;
    }

	@AuraEnabled
    public static void doBurrito(String myTrainingID){
        
        System.debug('doBurrito!! '+ myTrainingID);
    }
}