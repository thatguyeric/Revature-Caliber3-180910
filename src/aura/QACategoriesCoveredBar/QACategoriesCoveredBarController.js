({
	doInit : function(component, event, helper) {
        console.log('Inside QACategoriesCovered init. aaaaaah');
		var action = component.get("c.getCategories");
         console.log(component.get("v.TrainingID"));
        //var daID = component.get("v.TrainingID");
        action.setParams({ 
            myTrainingID : component.get("v.TrainingID"),
            Week_Number : component.get("v.WeekNumber")
        });
        action.setCallback(this, function(response) {
           var state = response.getState();
            if(state === "SUCCESS")
            {
            	component.set("v.categories", response.getReturnValue());
                console.log('categories have been fetched: '+response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	}

})