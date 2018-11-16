public class QASummaryController {

    /*@auraEnabled
    public static List<Integer> getAllQAStatus(String trainingValue, Integer selectedWeek){
        List<caliber_note__c> noteList = [SELECT qc_status__c FROM caliber_note__c WHERE training__c = :trainingValue AND week_number__c = :selectedWeek AND qc_status__c IN ('Poor','Average','Good','Superstar')];
        List<String> statusList = new List<String>();
        for(caliber_note__c c : noteList){
            statusList.add(c.qc_status__c);
        }
        List<Integer> calcList = new List<Integer>();
        for(String s: statusList){
            if(s == 'Poor'){
                calcList.add(1);
            }else if(s == 'Average'){
                calcList.add(2);
            }else if(s == 'Good'){
                calcList.add(3);
            }else{
                calcList.add(4);
            }
        }
        Integer totalQCScore = 0;
        for(Integer i: calcList){
            totalQCScore = totalQCScore + i;
        }
        system.debug(calcList);
        return calcList;
    }*/
    //Calcuates the average of qc scores, get a range, and then returns the String value according range
    @auraEnabled
    public static String calculateQAStatus(String trainingValue, Integer selectedWeek){
        System.debug('Event was fired');
        //Queries all the qc values in the training for the week.
        List<caliber_note__c> noteList = [SELECT qc_status__c FROM caliber_note__c WHERE training__c = :trainingValue AND week_number__c = :selectedWeek AND qc_status__c IN ('Poor','Average','Good','Superstar') AND note_type__c ='QC Trainee'];
        //Grabs all the qc_status__c into a List of Strings.
        List<String> statusList = new List<String>();
        for(caliber_note__c c : noteList){
            statusList.add(c.qc_status__c);
        }
        //Converts the Strings into a Integer Value.
        List<Integer> calcList = new List<Integer>();
        for(String s: statusList){
            if(s == 'Poor'){
                calcList.add(1);
            }else if(s == 'Average'){
                calcList.add(2);
            }else if(s == 'Good'){
                calcList.add(3);
            }else{
                calcList.add(4);
            }
        }
        //Initialized to determine average
        String qaValue;
        Integer totalQCScore = 0;
        //Adds all the values in a sum
        for(Integer i: calcList){
            totalQCScore = totalQCScore + i;
        }
        //Determines the range.
        Integer rangeValue = totalQCScore / 3;
        system.debug('Range value was: ' + rangeValue);
        //Determines the average score.
        System.debug('There are ' + calcList.size() + ' element(s) in calcList');
        Integer calculatedValue = totalQCScore / calcList.size();
        System.debug('Calculated value was: ' + calculatedValue);
        //Sets the qc value average for the training.
        if(calculatedValue == 1)
        {
            qaValue = 'Poor';
        }
        else if(calculatedValue == 2)
        {
            qaValue = 'Average';
        }
        else
        {
            qaValue = 'Good';
        }
        //Queries the record that will hold the average qc value then updates it.
        caliber_note__c trainingNote = [SELECT qc_status__c FROM caliber_note__c WHERE training__c = :trainingValue AND week_number__c = :selectedWeek AND note_type__c = 'QC Batch' LIMIT 1];
        trainingNote.QC_Status__c = qaValue;
        update trainingNote;
        return qaValue;
    }
    
    @auraEnabled
    //Grabs the value of the note from Lightning and updates the associated record for the training for the week.
    public static String updateOverallNotes(String trainingValue, Integer selectedWeek, String note){
        caliber_note__c aNote = [SELECT note_content__c FROM caliber_note__c WHERE training__c = :trainingValue AND week_number__c = :selectedWeek AND note_type__c = 'QC Batch' LIMIT 1];
    	aNote.Note_Content__c = note;
        system.debug(note);
        update aNote;
        return note;
    }
    
    //Loads the initial QA status when the page is loaded.
    @auraEnabled
    public static String initalQAStatus(String trainingValue, Integer selectedWeek){
        caliber_note__c overallQA = new caliber_note__c();
        List<caliber_note__c> noteList = [SELECT qc_status__c FROM caliber_note__c WHERE training__c = :trainingValue AND week_number__c = :selectedWeek AND note_type__c = 'QC Batch'];
        //If query returns an empty List, creates a QC Batch record for the training for that week.
        if(noteList.size() == 0){
            overallQA.training__c = trainingValue;
            overallQA.Note_Type__c = 'QC Batch';
            overallQA.Is_QC_Feedback__c = true;
            system.debug(selectedWeek);
            overallQA.Week_Number__c = Integer.valueOf(selectedWeek);
            system.debug(selectedWeek);
            insert overallQA;
            
        }else{
            //If query is not empty, grab the first one.
            overallQA = noteList[0];
        }
        String qaStatus = overallQA.QC_Status__c;
        system.debug(qaStatus);
        return qaStatus;
    }
    
    @auraEnabled
    //Grabs the current note for the training for the week.
    public static String initalQANote(String trainingValue, Integer selectedWeek){
        System.debug('trainingcalue: ' + trainingValue);
        System.debug('selected week: ' + selectedWeek);
        caliber_note__c aNote = [SELECT note_content__c FROM caliber_note__c WHERE training__c =:trainingValue AND week_number__c = :selectedWeek AND note_type__c = 'QC Batch' LIMIT 1];
    	String note = aNote.Note_Content__c;
        return note;
    }
    
    @auraEnabled
    //Grabs the current average for the record.
    public static void updateQABatchRecord(String trainingValue, Integer selectedWeek, String qaValue){
        caliber_note__c overallQA = [SELECT qc_status__c FROM caliber_note__c WHERE training__c = :trainingValue AND week_number__c = :selectedWeek AND note_type__c = 'QC Batch' LIMIT 1];
        overallQA.qc_status__c = qaValue;
        update overallQA;
    }
}