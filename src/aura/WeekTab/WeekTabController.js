({
    /* DoInit runs as soon as the component is created. It is in charge of creating
     * the necesary number of tabs that exist for the batch selected by default
     * ******************************************************************************/
    doInit : function(cmp, evnt, hlpr){
        console.log('before getCurrentBatch WeekTabController.js');
        var action = cmp.get('c.getCurrentBatch');
        console.log('after getCurrentBatch WeekTabController.js');
        action.setCallback(this, function(response){
            // this will pre-load all of the weeks from week 1 to the training's
            // current 'Caliber Number of Weeks' field
            if(response.getState()==='SUCCESS'){
                cmp.set('v.currentBatch',response.getReturnValue());
                for(let i=0;i<cmp.get('v.currentBatch.Caliber_Number_of_Weeks__c')-1;i++){
                    // go add a tab component
                    hlpr.addTab(cmp,evnt);
                }
            }else {
                throw new Error(error);
            }
        });
        $A.enqueueAction(action);        
        
        // action 2 is used to set the local attribute of getCurrentBatchID
        var action2 = cmp.get('c.getCurrentBatchID');        
        action2.setCallback(this, function(response){            
            if(response.getState()==='SUCCESS'){
                cmp.set('v.currentBatchID',response.getReturnValue());
                
            }else {
                throw new Error(error);
            }
        });
        $A.enqueueAction(action2);        
        
    },
    
    // Use handleActive to set the active content, meaning that it will 
    // grab the selected tab and loading the content specific for that tab.
    // See more details in the helper
    handleActive: function (cmp, event, helper) {
        var BatchId = cmp.get('v.currentBatchID');       
        helper.handleActive(cmp, event, BatchId);
        cmp.set("v.tabId","Week1");
    },
    
    // Creates a new tab when the + labeled tab is clicked, which in turn will
    // increment the Training's current number of weeks as well as create blank
    // QA notes for each trainee
    handleAddTab: function(component, event, helper) {
        // console.log(document.getElementById('addTab').innerHTML);
        helper.addTab(component,event);
        var action = component.get('c.incrementWeek');
        action.setParams({batch:component.get('v.currentBatch')});
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                component.set('v.currentBatch',response.getReturnValue());                
            }
        });
        $A.enqueueAction(action);
        
    },    
    testFocus : function(component,event,helper){
        console.log('focus');
    },
    
    // When the selected batch is changed in the QAMenuSelect component, this
    // segment is in charge of catching the fired event and updating the 
    // currentBatchID atrribute
    handleChange : function(component,event,helper){
        var tempv = event.getParam("currentBatchID");
        component.set("v.currentBatchID", tempv);
        console.log("Event caught! " + component.get('v.currentBatchID'));
        
        var action = component.get('c.getCurrentBatch');
        action.setParams({batchId:tempv});
        action.setCallback(this, function(response){
            // this will pre-load all of the weeks from week 1 to the training's
            // current 'Caliber Number of Weeks' field
            
            if(response.getState()==='SUCCESS'){
                // console.log('old # of weeks is '+ component.get('v.currentBatch.Caliber_Number_of_Weeks__c'));
                // console.log(component.get('v.currentBatch'));
                component.set('v.currentBatch',response.getReturnValue());
                // console.log('new # of weeks is '+ component.get('v.currentBatch.Caliber_Number_of_Weeks__c'));
                // console.log(component.get('v.currentBatch'));
                
                // console.log('more tabs length = '+component.get("v.moretabs").length);                
                // clean out the extra tabs
                helper.removeMoreTabs(component,event);                  
                //console.log('more tabs = '+component.get('v.moreTabs').length);
                
                // now to add the additional tabs
                for(let i=0;i<component.get('v.currentBatch.Caliber_Number_of_Weeks__c')-1;i++){
                    // go add a tab component                    
                    helper.addTab(component,event);
                }
            }else {
                throw new Error(error);
            }
        });
        $A.enqueueAction(action); 
    }
})