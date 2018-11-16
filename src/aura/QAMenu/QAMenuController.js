({
    init: function (cmp,event,helper) {
        var options = [];
        var action = cmp.get("c.GetAllYearsWithBatches");
        //Sets the selected value of currentYear attribute to the current year
        cmp.find("selectYear").set("v.value", new Date().getFullYear().toString());
        //cmp.set("v.currentYear",new Date().getFullYear().toString());
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                //Sets the yearOption attribute to the list returned from the Apex controller
                var arr = response.getReturnValue();
                arr.forEach(function(element){
                    options.push({value: element.toString(), label:element});
                });
                cmp.set("v.yearOptions",options);
            }
            
        });
        $A.enqueueAction(action);
        //Calls a helper to set the training combobox to the year selected
        helper.buildQuartersForYear(cmp,event);        
    },
    updateTrainingLabel: function (cmp, event,helper) {
        //Refreshes the training list to the selected year
        var label = event.getSource().get("v.value");
        cmp.set("v.locationValue",label);
        console.log(cmp.get("v.locationValue"));
        helper.changeTraining(cmp,event);
    },
    
    updateQuarterLabel: function(cmp,event,helper){
        var label = event.getSource().get("v.value");
        cmp.set("v.currentYear",label);
        helper.buildQuartersForYear(cmp,event);
    },
    
    updateLocationLabel: function(cmp,event,helper){
        var label = event.getSource().get("v.value");
        cmp.set("v.currentQuarter",label);
        helper.buildLocations(cmp,event);
        
    },
    //TODO: Pass value to parent app
    updateTraining: function(cmp,event,helper){
        //Debug Code
    	var label = cmp.get("v.trainingValue");
        cmp.set("v.temp2",label);
        var label2 = event.getParam("value");
        var appEvent = $A.get("e.c:updateBatchIDEvent");
        appEvent.setParams({"currentBatchID" : label2});
        appEvent.fire();
	}
})