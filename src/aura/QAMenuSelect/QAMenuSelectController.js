({
    init: function (cmp,event,helper) {
        console.log('Current Training ID: '+cmp.get('v.currentTraining.Id'));
        var options = [];
        var action = cmp.get("c.GetAllYearsWithBatches");
        //Sets the selected value of currentYear attribute to the current year
        cmp.set("v.currentYear",new Date().getFullYear().toString());
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
        helper.changeTrainingForYear(cmp);
        
    },
    updateYearLabel: function (cmp, event,helper) {
        //Refreshes the training list to the selected year
        helper.changeTrainingForYear(cmp);
        var yearLabel = event.getSource().get("v.value");
        console.log(event.getParam("value"));
        cmp.set("v.currentYear", yearLabel);
    },
    
    //TODO: Pass value to parent app
    updateTraining: function(cmp,event,helper){
        var selectedOptionValue = event.getParam("value");

        var newComponents = [];
        newComponents.push(["c:ColumnBtn",
                            {
                                "batchID" : selectedOptionValue
                                
                            }]);
        newComponents.push(["c:weekTabMenu",
                            {
                                "batchID" : selectedOptionValue
                                
                            }]);
       
        //Dynamic nested component
        $A.createComponents(newComponents,
                            function (components, status, errorMessage) {
                                if (status === "SUCCESS") {
                                    
                                    var pageBody = [];
                                    for (var i = 0; i < components.length; i += 2) {
                                        var btn = components[i];
                                        var tabs = components[i + 1];
                                        
                                        //var tdBody = td.get("v.body");
                                        //tdBody.push(div);
                                        //td.set("v.body", tdBody)
                                        pageBody.push(btn);
                                        pageBody.push(tabs);
                                    }
                                    cmp.set("v.body", pageBody);
                                    console.log('inserted components');
                                }
                                else // Report any error
                                {
                                    this.displayToast("Error", "Failed to create list components.");
                                }
                            });
        
        //alert("Option selected with value: '" + selectedOptionValue + "'");
    }
})