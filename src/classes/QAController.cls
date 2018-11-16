public class QAController {
    
    @AuraEnabled
    //Builds a list of all the training sObjects with a start date equal with the year parameter passed in.
    public static List<Training__c> getBatchesByYear(Integer year, String quarter, String location){
        //Creates Dates for the SOQL clause. One for the beginning and one for the end.
        List<Date> dateRange = getQuarterDateRange(quarter,year);
        //Queries the training list for the year parameter.
        List<Training__c> batchList =  [SELECT Id, Trainer__c, TrainingTrack__c, startDate__c, Caliber_Number_of_Weeks__c
                                        FROM Training__c
                                        WHERE training_location_name__c = :location AND ((startDate__c >= : dateRange[0] AND startDate__c <= : dateRange[1])
        								//Not working for some reason
        								OR (endDate__c >= : dateRange[0] AND endDate__c <= : dateRange[1]))];
        //system.debug('batchlist from qacontroller line 14' + batchList);
        return batchList;
    }

    @AuraEnabled
    //Creates the list with all years currently inside database.
    public static List<Integer> GetAllYearsWithBatches(){
        List<AggregateResult> trainings = [select count(Id), CALENDAR_YEAR(StartDate__c) from Training__c group by CALENDAR_YEAR(StartDate__c) ORDER BY CALENDAR_YEAR(StartDate__c) DESC];
        List<Integer> years = new List<Integer>();
        //Grabs year from aggregateResult returned from the query.
        for (AggregateResult ar : trainings){
            years.add((Integer)ar.get('expr1'));
        }
        return years;
    }
    
    @AuraEnabled
    //Creates the options for the quarter combobox
    public static List<String> getAllQuarters(Integer year){
        //Creates Dates for the SOQL clause. One for the beginning and one for the end.
        Date startOfYear = date.newInstance((Integer)year, 1, 1);
        Date endOfYear = date.newInstance((Integer)year, 12, 31);
        //Queries the training list for the year parameter.
        List<Training__c> trainingList =  [SELECT startDate__c
                                        FROM Training__c
                                        WHERE (startDate__c >= : startOfYear AND startDate__c <= : endOfYear) 
                                        OR (endDate__c >= : startOfYear AND endDate__c <= : endOfYear)];
        //system.debug('training list from qacontroller apex line 41' + trainingList);
        //Set was created to ensure no duplicates
        Set<String> quarterSet = new Set<String>();
        //If-Else to add a corresponding quarter to the set
        for(Training__c t: trainingList){
            if(t.StartDate__c >= date.newInstance(year,1,1) && t.StartDate__c <= date.newInstance(year,3,date.daysInMonth(year, 3))){
                quarterSet.add('Q1');
            }else if(t.StartDate__c >= date.newInstance(year,3,1) && t.StartDate__c <= date.newInstance(year,6,date.daysInMonth(year, 6))){
                quarterSet.add('Q2');
            }else if(t.StartDate__c >= date.newInstance(year,6,1) && t.StartDate__c <= date.newInstance(year,9,date.daysInMonth(year, 9))){
                quarterSet.add('Q3');
            }else{
                quarterSet.add('Q4');
            }
        }
        //Convert Set to List and then is returned
        List<String> quarterList = new List<String>();
        quarterList.addAll(quarterSet);
        return quarterList;
    }
    
    @AuraEnabled
    //Creates the location options for the combo box
    public static List<String> getLocations(String quarter,Integer year){
        //Grabs the date range according the getQuarterDateRange
        List<Date> dateRange = getQuarterDateRange(quarter,year);
        //Set is created to ensure no duplicates.
        Set<String> locationSet = new Set<String>();
        List<String> locationNames = new List<String>();
        List<Training__c> trainingList = [SELECT Training_Location_Name__c FROM Training__C WHERE StartDate__c >= :dateRange[0] AND StartDate__c <= :dateRange[1]];
       
        for(Training__c t: trainingList ){
            locationSet.add(t.Training_Location_Name__c);
        }
        //Converted Set to List and then returned
        locationNames.addAll(locationSet);
        return locationNames;
    }
    
    @AuraEnabled
    //Method to return a start and end date range according to the quarter and year parameter sent in.
    public static List<Date> getQuarterDateRange(String quarter, Integer year){
        List<Date> dateList = new List<Date>();
        if(quarter == 'Q1'){
            dateList.add(date.newInstance(year,1,1));
            dateList.add(date.newInstance(year,3,date.daysInMonth(year, 3)));
        }else if(quarter == 'Q2'){
            dateList.add(date.newInstance(year,4,1));
            dateList.add(date.newInstance(year,6,date.daysInMonth(year, 6)));
        }else if(quarter == 'Q3'){
            dateList.add(date.newInstance(year,7,1));
            dateList.add(date.newInstance(year,9,date.daysInMonth(year, 9)));
        }else{
            dateList.add(date.newInstance(year,10,1));
            dateList.add(date.newInstance(year,12,date.daysInMonth(year, 12)));
        }
        return dateList;
    }
    
    //build a list of strings for all batches in year.
    @AuraEnabled
    public static List<String> buildBatchStrings(List<Training__c> trainings){
        //system.debug('line 103 qacontroller apx '+ trainings);
        List<String> batchStrings = new List<String>();
        //Puts all trainer ids from the training sObject into a list.
        List<Id> trainerIds = new List<Id>();
        for (Training__c training : trainings){
            trainerIds.add(training.Trainer__c);
        }
        //Queries all users with the id equal to training id.
        List<User> userTrainers = [select id, name from User where id in :trainerIds];
        
        //Creates the list with formatted string with the training id, trainer name, and training start date concatenated into one.
        //Will be split inside JavaScript controller.
        for (Training__c training : trainings){
            for (User trainer : userTrainers){
                if (trainer.id == training.Trainer__c){
            		String tString = training.id + ',' + trainer.Name + ' ' + training.startDate__c.format();
                    batchStrings.add(tString);
                }
            }
        }
        return batchStrings;        
    }
    
    @AuraEnabled
    public static Training__c findCurrentBatch(String trainingValue){
        //System.debug('line 128 inside findCurrentBatch. id= ' +trainingValue);
        Training__c currentT = [SELECT Id, Trainer__c, TrainingTrack__c, startDate__c, Caliber_Number_of_Weeks__c
                                FROM Training__c
                                WHERE ID=:trainingValue];
        //System.debug('line 131 qa controller.apx current trainings id: ' + currentT.id );
        return currentT;
    }
}//end of ReportsController class