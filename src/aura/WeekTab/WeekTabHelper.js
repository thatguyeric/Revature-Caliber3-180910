({
    handleActive: function (cmp, event, BatchId) {
        var tab = event.getSource();
        // When the tab becomes active, find the tab by the id and inject the corresponding content.
        // See this example for how this will need to be done. 
        var week = tab.get('v.id').split('k')[1];        
        // This line is what actually 'inserts' the content of the tab into the page        
        this.injectComponent('c:QABatchTable', tab, week, BatchId);
        //console.log('tab injected');
    },
    
    injectComponent: function (name, target, week, BatchId) {
        // inserts the content into the tab, which in this case means create
        // a new 'QABatchTable' component and give it the necessary attributes        
        $A.createComponent(name, {
            "week" : week,            
            "currentBatchID" : BatchId
        }, function (contentComponent, status, error) {
            if (status === "SUCCESS") {
                target.set('v.body', contentComponent);                
            } else {
                throw new Error(error);
            }
        });
    },
    
    addTab: function(component, event) {
         // Find how many 'extra' tabs exist already, then adjust the number to
         // match what the new tab's label and Id will be
         var i = component.get("v.moretabs").length;
         i = i+2; // if there are no extra tabs, i starts at 0, so first created tab should be Week 2
        console.log('Adding tab #'+i);
        $A.createComponent("lightning:tab", {
            // first create the new tab component, give it the same format as the other tabs
            "label": "Week "+i,
            "id": "Week"+i,
            "class": "slds-m-left_large, weekly-tab",
            "onactive": component.getReference("c.handleActive")
        }, function (newTab, status, error) {
            // add that tab!            
            if (status === "SUCCESS") {
                // this way, the new tab is appened to moretabs, instead of just overriding. 
                var body = component.get("v.moretabs");
                body.push(newTab);
                component.set("v.moretabs", body);
            } else {
                throw new Error(error);
            }
        });
    },
    
    // When the event from the QAMenuSelect component fires, WeekTabMenu has to update its'
    // attributes. 
    // NOTE: THIS SHOULD ALSO DESTROY ANY NON-EXISTING TABS IN ORDER TO SHOW DATA FOR THE SELECTED BATCH
    reloadOnEventFire : function(component, event){        
        var action = cmp.get('c.getCurrentBatch');        
        action.setCallback(this, function(response){
            // this will pre-load all of the weeks from week 1 to the training's
            // current 'Caliber Number of Weeks' field
            if(response.getState()==='SUCCESS'){
                cmp.set('v.currentBatch',response.getReturnValue());
                for(let i=0;i<cmp.get('v.currentBatch.Caliber_Number_of_Weeks__c')-1;i++){
                    hlpr.addTab(cmp,evnt);
                }
            }else {
                throw new Error(error);
            }
        });
        $A.enqueueAction(action);        
        
        var action2 = cmp.get('c.getCurrentBatchID');        
        action2.setCallback(this, function(response){
            // this will pre-load all of the weeks from week 1 to the training's
            // current 'Caliber Number of Weeks' field
            if(response.getState()==='SUCCESS'){
                cmp.set('v.currentBatchID',response.getReturnValue());                              
            }else {
                throw new Error(error);
            }
        });
        $A.enqueueAction(action2);
    },
    removeMoreTabs: function(component, event) {
         // Find how many 'extra' tabs exist already, then adjust the number to
         // match what the new tab's label and Id will be
        console.log('Cleanup!');
        var i = component.get("v.moretabs").length;
       
        console.log('tabs to remove: '+ i);
        var tabs = component.get("v.moretabs");
        tabs.splice(0,i);
        component.set("v.moretabs",tabs);         
    },
})