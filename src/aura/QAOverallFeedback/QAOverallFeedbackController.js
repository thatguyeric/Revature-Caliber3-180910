({
    //Runs at the inital load of the page.
    init : function(component,event,helper){
        var trainingValue = component.get("v.trainingValue");
        var selectedWeek = component.get("v.selectedWeek");
        //Calls a method in the Apex controller to get the current average in the database.
        var action = component.get("c.initalQAStatus");
        action.setParams({"trainingValue":trainingValue,"selectedWeek":selectedWeek});
        action.setCallback(this, function(response) {
        	var state = response.getState();
            //If callback is successful, set the color of the correct face.
            if(state === "SUCCESS"){
                console.log(response.getReturnValue());
             	var returnedValue = response.getReturnValue();
                if(returnedValue == "Poor"){
                    helper.setSadColor(component);
                }else if(returnedValue == "Average"){
                    helper.setNeutralColor(component);
                }else if(returnedValue == "Good"){
                    helper.setSmileColor(component);
                }
            }
        });
    	$A.enqueueAction(action);
        //Call the Apex method to get the current notes from the database.
        var action2 = component.get("c.initalQANote");
        action2.setParams({"trainingValue":trainingValue,"selectedWeek":selectedWeek});
        action2.setCallback(this, function(response){
            //If successful, set the noteValue attribute to the value from the database.
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.noteValue", response.getReturnValue());
            }
        });
        $A.enqueueAction(action2);
    },
    
    //Runs when the smile face is clicked
    smileClicked : function(component,event,helper){
        helper.setSmileColor(component);
        var action = component.get("c.updateQABatchRecord");
        var trainingValue = component.get("v.trainingValue");
        var selectedWeek = component.get("v.selectedWeek");
        //Call a Apex method that updates the qc_status__c of the record to 'Good'
        action.setParams({"trainingValue":trainingValue,"selectedWeek":selectedWeek,"qaValue":"Good"});
        //Nothing right now
        action.setCallback(this, function(response){
            //var state = response.getState();
            //if(state === "SUCCESS"){
  				
            //}
        });
        $A.enqueueAction(action);                 
        
    },
    //Runs when the meh face is clicked
    neutralClicked : function(component,event,helper){
        helper.setNeutralColor(component);
        var action = component.get("c.updateQABatchRecord");
        var trainingValue = component.get("v.trainingValue");
        var selectedWeek = component.get("v.selectedWeek");
		//Call a Apex method that updates the qc_status__c of the record to 'Average'
        action.setParams({"trainingValue":trainingValue,"selectedWeek":selectedWeek,"qaValue":"Average"});
		//Nothing right now
        action.setCallback(this, function(response){
            //var state = response.getState();
            //if(state === "SUCCESS"){
                
            //}
        });
        $A.enqueueAction(action);                 
        
        
    },
    //Runs when the sad face is clicked
    sadClicked : function(component,event,helper){
        helper.setSadColor(component);
        var action = component.get("c.updateQABatchRecord");
        var trainingValue = component.get("v.trainingValue");
        var selectedWeek = component.get("v.selectedWeek");
        //Call a Apex method that updates the qc_status__c of the record to 'Poor'
        action.setParams({"trainingValue":trainingValue,"selectedWeek":selectedWeek,"qaValue":"Poor"});
        //Nothing right now
        action.setCallback(this, function(response){
            //var state = response.getState();
            //if(state === "SUCCESS"){
                
            //}
        });
        $A.enqueueAction(action);                   
    },
    //When called, will query the database to get the average score. Returns a String value to determine which face to color
    recalculateQAAverage: function(component,event,helper){
        var trainingValue = component.get("v.trainingValue");
        var selectedWeek = component.get("v.selectedWeek");
        var action = component.get("c.calculateQAStatus");
        action.setParams({"trainingValue":trainingValue,"selectedWeek":selectedWeek});
        //Calls a Apex method that returns the String value to correctly color the right face
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log(response.getReturnValue());
                if(response.getReturnValue() == "Good"){
                    helper.setSmileColor(component);
                }else if(response.getReturnValue() == "Average"){
                    helper.setNeutralColor(component);
                }else{
                    helper.setSadColor(component);
                }
            }
        });
        $A.enqueueAction(action);
    },
    //Runs when user clicks outside of textarea
    updateOverallTextbox : function(component,event,helper){
        var trainingValue = component.get("v.trainingValue");
        var selectedWeek = component.get("v.selectedWeek");
        //Grabs the value of the text area.
        var note = event.getSource().get("v.value");
        var action = component.get("c.updateOverallNotes");
        //Sends the value of the note and then updates the record associated to it.
        action.setParams({"trainingValue":trainingValue,"selectedWeek":selectedWeek,"note":note});
        //Nothing right now
        action.setCallback(this, function(response){
            //var state = response.getState();
            //if(state === "SUCCESS"){
                //console.log(response.getReturnValue());
            //}
        });
        $A.enqueueAction(action);
    }
   
   
    
})