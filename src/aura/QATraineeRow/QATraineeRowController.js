({
    /*
     * Calls the GetTraineeInfo function in the apex controller and populates the 
     * aura attribute with the returned value.
     */
    getTrainee : function(component, event, helper) {
        /*The init function needs to populate the component with existing data*/
        var action = component.get("c.GetTraineeInfo");
        //console.log(action);
        action.setParams({
            Training_Assignment : component.get("v.trainingAssignment")
        });
        action.setCallback(this, function(response){
           var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.trainingAssignment", response.getReturnValue());
                console.log('trainee info updated');
            }
            else
            {
                console.log("Response was: " + state);
            }
        });
        $A.enqueueAction(action);
	},
	
	/*
	 * This function retrieves caliber note information from the apex controller
	 * based on the week number and the trainee and applies the QC Status and Note
	 * Content values to the component.
	 */     
    getComponentInfo : function(component, event, helper) {
        var action = component.get("c.getCaliberNote");
        console.log('getComponentInfo trainingAssignmentId ='+component.get("v.trainingAssignment.id"));
        console.log('getComponentInfo week ='+component.get("v.WeekNumber"));
        action.setParams({
            Training_Assignment_Id : component.get("v.trainingAssignment.id"),
            Week_Number : component.get("v.WeekNumber")
        });
        action.setCallback(this, function(response) {
           var state = response.getState();
            if(state === "SUCCESS")
            {
                component.set("v.NoteContent", response.getReturnValue().Note_Content__c);
                component.set("v.QCStatus", response.getReturnValue().QC_Status__c);
                if(component.get("v.QCStatus") == "Superstar")
                {
                    component.set("v.iconLabel", "Excellent");
                    component.set("v.icon", "fa fa-star fa-2x");
                }
                else if(component.get("v.QCStatus") == "Good")
                {
                 	component.set("v.iconLabel", "Good");
                    component.set("v.icon", "fa fa-smile-o fa-2x");
                }
                else if(component.get("v.QCStatus") == "Average")
                {
                    component.set("v.iconLabel", "Fair");
                    component.set("v.icon", "fa fa-meh-o fa-2x");    
                }
                else if(component.get("v.QCStatus") == "Poor")
                {
                    component.set("v.iconLabel", "Poor");
                    component.set("v.icon", "fa fa-frown-o fa-2x");
                }
                else
                {
                    component.set("v.iconLabel", "Click to update your feedback.");
                    component.set("v.icon", "fa fa-question-circle fa-2x");
                }
         	}
        });
        $A.enqueueAction(action);
    },
    
    /*
    * Whenever the QC assessment icon is clicked, this function checks the current
    * value of the icon attribute and adjusts the value accordingly to update the 
    * icon.
    * This function also saves the user's final selection to the database,
    * passing the following variables to the apex controller:
    * 		-The trainee's training assessment ID.
    * 		-The trainee's QC assessment value.
    * 		-The week number for the quality audit.
    */ 
    handleClick : function(component, event, helper) {
        
        if(component.get("v.icon") == "fa fa-question-circle fa-2x")
        {
            component.set("v.icon", "fa fa-star fa-2x");
            component.set("v.iconLabel", "Excellent");
            component.set("v.QCStatus", "Superstar");
        }
        else if(component.get("v.icon") == "fa fa-star fa-2x")
        {
            component.set("v.icon", "fa fa-smile-o fa-2x");
            component.set("v.iconLabel", "Good");
            component.set("v.QCStatus", "Good");
        }
        else if(component.get("v.icon") == "fa fa-smile-o fa-2x")
        {
            component.set("v.icon", "fa fa-meh-o fa-2x");
            component.set("v.iconLabel", "Fair");
            component.set("v.QCStatus", "Average");
        }
        else if(component.get("v.icon") == "fa fa-meh-o fa-2x")
        {
            component.set("v.icon", "fa fa-frown-o fa-2x");
            component.set("v.iconLabel", "Poor");
            component.set("v.QCStatus", "Poor");
        }
        else
        {
  			component.set("v.icon", "fa fa-question-circle fa-2x");
            component.set("v.iconLabel", "Click to update your feedback.");
            component.set("v.QCStatus", "Undefined");
        }
        var action = component.get("c.SaveTraineeQC");
        action.setParams({
            Training_Assignment : component.get("v.trainingAssignment"),
            Assessment : component.get("v.QCStatus"),
            Week_Number : component.get("v.WeekNumber")
        });
        action.setCallback(this, function(response) {
           var state = response.getState();
            if(state === "SUCCESS")
            {
                var evt = $A.get("e.c:updateQCAverageEvent");
                evt.fire();
                console.log('Save was successful');
            }
        });
        $A.enqueueAction(action);
    },
    /*
     * Whenever the user blurs away from the trainee note section, this function saves
     * the user's final result to the database, passing the following variables to the
     * apex controller:
     * 		-The trainee's training assignment ID.
     * 		-The contents of the note section.
     * 		-The week number of the quality audit.
     */ 
    handleBlurOnNote : function(component, event, helper) {
        var action = component.get("c.SaveTraineeNote");
        action.setParams({
           Training_Assignment : component.get("v.trainingAssignment"),
            Note : component.get(("v.NoteContent")),
            Week_Number : component.get("v.WeekNumber")
        });
        action.setCallback(this, function(response) {
           var state = response.getState();
            if(state === "SUCCESS")
            {
                console.log('Save was successful');
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    /* Possible doInit replacement that grabs and sets all major attributes 
    */
    getEverything: function (component, event, helper){
        console.log('getting everything!')
        var action = component.get("c.GetTraineeID");
        //console.log(action);
        action.setParams({
            Training_Assignment : component.get("v.trainingAssignment")
        });
        action.setCallback(this, function(response){
           var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.trainingAssignmentID", response.getReturnValue());
                //console.log('Setting assignment id' + response.getReturnValue());
                // -----------------------------------------------
                 var action2 = component.get("c.GetTraineeInfo");
                //console.log(action);
                action2.setParams({
                    Training_Assignment : component.get("v.trainingAssignment")
                });
                action2.setCallback(this, function(response){
                   var state = response.getState();
                    if(state === "SUCCESS") {
                        component.set("v.trainingAssignment", response.getReturnValue());
                        //console.log('trainee info updated');
                             // -------------------------------
                        var action3 = component.get("c.getCaliberNote");
                       // console.log('nested actions');
                       // console.log('getComponentInfo trainingAssignmentId ='+component.get("v.trainingAssignmentID"));
                       // console.log('getComponentInfo week ='+component.get("v.WeekNumber"));
                        action3.setParams({
                            Training_Assignment : component.get("v.trainingAssignment"),
                            Week_Number : component.get("v.WeekNumber")
                        });
                        action3.setCallback(this, function(response) {
                           var state = response.getState();
                            if(state === "SUCCESS")
                            {	console.log('Setting QC stuff');
                                component.set("v.NoteContent", response.getReturnValue().Note_Content__c);
                                component.set("v.QCStatus", response.getReturnValue().QC_Status__c);
                                if(component.get("v.QCStatus") == "Superstar")
                                {
                                    component.set("v.iconLabel", "Excellent");
                                    component.set("v.icon", "fa fa-star fa-2x");
                                }
                                else if(component.get("v.QCStatus") == "Good")
                                {
                                    component.set("v.iconLabel", "Good");
                                    component.set("v.icon", "fa fa-smile-o fa-2x");
                                }
                                else if(component.get("v.QCStatus") == "Average")
                                {
                                    component.set("v.iconLabel", "Fair");
                                    component.set("v.icon", "fa fa-meh-o fa-2x");    
                                }
                                else if(component.get("v.QCStatus") == "Poor")
                                {
                                    component.set("v.iconLabel", "Poor");
                                    component.set("v.icon", "fa fa-frown-o fa-2x");
                                }
                                else
                                {
                                    component.set("v.iconLabel", "Click to update your feedback.");
                                    component.set("v.icon", "fa fa-question-circle fa-2x");
                                }
                            }
                        });
                        $A.enqueueAction(action3);   
                    }
                    else
                    {
                        console.log("Response was: " + state);
                    }
                });
                $A.enqueueAction(action2);
                
            }
            else
            {
                console.log("Response was: " + state);
            }
        });
        $A.enqueueAction(action);
        // ----------------------------------------
        
    }
})