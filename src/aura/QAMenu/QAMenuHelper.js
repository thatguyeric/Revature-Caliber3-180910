({
    changeTraining : function(cmp,event){
    	var options = [];
        //Grabs all the batches for the year selected
    	var action = cmp.get("c.getBatchesByYear");
        var year = cmp.get("v.currentYear");
        var quarter = cmp.get("v.currentQuarter");
        var location = cmp.get("v.locationValue");
        action.setParams({"year":year,"quarter":quarter,"location":location});
        action.setCallback(this, function(response){
            var state = response.getState();
            //If successful, will set the trainingList attribute
            if(state === "SUCCESS"){
                console.log("change training " + response.getReturnValue());
                cmp.set("v.trainingList",response.getReturnValue());
                //Calls buildTrainingStrings to build the label and value for the combobox for trainings
                this.buildTrainingStrings(cmp, event);                
            }
        });
        $A.enqueueAction(action);
        
	},
    
    //Build the Quarter List and selected value for the quarter
    buildQuartersForYear : function(cmp,event){
        var options = [];
        console.log("building quarters for year");
        var year = cmp.get("v.currentYear");
        //Get the quarter for the current date.
        var currentDate = new Date().getMonth();
        //Sets a string value associated to the date.
        var currentQuarter;
        if(currentDate < 3){
            currentQuarter = "Q1"
        }else if(currentDate < 6){
            currentQuarter = "Q2"
        }else if(currentDate < 9){
            currentQuarter = "Q3"
        }else{
            currentQuarter = "Q4"
        }
        //quarterExist is here to check if the current quarter for current day is in the array returned from the Apex controller. If not, get most recent quarter.
        var quarterExist = false;
        cmp.set("v.currentQuarter",currentQuarter);
        var action = cmp.get("c.getAllQuarters");
        action.setParams({"year":year});
        action.setCallback(this,function(response){
           var state = response.getState();
            if(state === "SUCCESS"){
                //Grabs the quarter list from the Apex controller
                var arr = response.getReturnValue();
                console.log('test' + arr);
                //For each loop to check if the current day quarter exist.
                arr.forEach(function(element){
                    if(currentQuarter === element){
                        quarterExist = true;
                    }
                    options.push({value: element, label:element});
                    
                });
                //Sets the selected quarter to most recent quarter from the list if quarterexist is false.
                if(quarterExist == false){
                	cmp.set("v.currentQuarter",response.getReturnValue()[response.getReturnValue.length]);
                    //console.log(response.getReturnValue()[response.getReturnValue.length]);
                }
                //Sets the quarter combobox and then calls the buildLocations function
                cmp.set("v.quarterList",options);
                this.buildLocations(cmp,event);
            }
        });
        $A.enqueueAction(action);
    },
    
    buildLocations : function(cmp,event){
        var options = [];
        //Grabs the currentYear value and currentQuarter value.
        var selectedYear = cmp.get("v.currentYear");
        var currentQuarter = cmp.get("v.currentQuarter");
        var action = cmp.get("c.getLocations");
        //Calls the getLocations method in the Apex Controller and sets its parameters.
        action.setParams({"quarter":currentQuarter,"year":selectedYear});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                //Gets the return value from the Apex controller and sets the the location combobox
                var arr = response.getReturnValue();
                arr.forEach(function(element){
                    options.push({value: element, label:element});       
                });
            }
            //Sets the LocationList and value according to the options from the select list.
            cmp.set("v.locationList", options);
            cmp.set("v.locationValue", options[0].value);
            this.changeTraining(cmp,event);
            var temp = event.getParam("value");
            cmp.set("v.temp3",temp);
        })
        $A.enqueueAction(action);
        //Debug Code -- To be removed
        var testValue = cmp.get("v.trainingValue");
        var testv2 = cmp.find("selectTraining").get("v.value");
        cmp.set("v.temp",testValue + ' ' + testv2);
    },
    
    buildTrainingStrings : function(cmp,event){
        var action = cmp.get("c.buildBatchStrings");
        //Grabs the list of trainers
        var trainingList = cmp.get("v.trainingList");
        var options = [];
        action.setParams({"trainings":trainingList});
        //Send the list of trainings to build the formatted list of Trainer and start date
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var allStrings = response.getReturnValue();
                var tempString =[];
                //Splits the List of Strings into a List of List of Strings
                for(var i = 0; i < allStrings.length;i++){
                    tempString.push(allStrings[i].split(","));   
                }
                //Sets the Combobox: Training id as the value/Formatted trainer name and training start_date as the label
                tempString.forEach(function(element){
                        options.push({value:element[0],label:element[1]});
                    });
                	//Sets the list of trainers and starts dates
                    cmp.set("v.trainingOptions",options);
                	//Sets the value for the selected training
                	cmp.set("v.trainingValue",tempString[0][0]); 
                     
                	var getThatEvent = $A.get("e.c:updateBatchIDEvent");
                	getThatEvent.setParams({"currentBatchID" : tempString[0][0]});
                	getThatEvent.fire();
                	console.log('the event has been fired!');
                
                    // -------- gina added this here part --------
                    var action2 = cmp.get("c.findCurrentBatch");
                    var batchIdString = cmp.get("v.trainingValue");

                    action2.setParams({"trainingValue": batchIdString});
                    action2.setCallback(this,function(response){
                        var state = response.getState();
                        if(state === "SUCCESS"){
                            var currentTraining = response.getReturnValue();
                            cmp.set("v.currentBatch",currentTraining);
                        }
                    });
                   $A.enqueueAction(action2);  
                var getTv = cmp.get("v.trainingValue");
            }
        });
        $A.enqueueAction(action);
    },
   
    updateTheBatchID : function(component, event, helper){
        var tempv = event.getParam("currentBatchID");
        component.set("v.currentBatchID", tempv);
        console.log('we are updating the batchID~! id= '+ tempv);
    }
})