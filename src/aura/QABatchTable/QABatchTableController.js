({
    doInit : function(component, event, helper) {
        var theID = component.get("v.currentBatchID"); 
        console.log('theID: ' + theID);
        var action = component.get("c.getAssociates");        
        action.setParams({ batchID : theID});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(response.getState()==='SUCCESS'){
                component.set("v.associates",response.getReturnValue());
            }
        });       
        
        $A.enqueueAction(action);
    },
    
    // used to save the Overall batch notes
    saveNotes : function(component, event, helper){
        var saveEvent = $A.get('e.c:saveNotes');
        saveEvent.fire();
        
    },
    
    // updates the batchid when the event from the QAMenuSelect component is fired
    updateTheBatchID : function(component, event, helper){
        // var tempv = event.getParam("currentBatchID");
        // component.set("v.currentBatchID", tempv);
        // console.log('we are updating the batchID~! id= '+ tempv);
        // 
        var tempv = event.getParam("currentBatchID");
        component.set("v.currentBatchID", tempv);
        console.log('Event caught! we are updating the batchID~! id= '+ tempv);
        
        var action = component.get("c.getAssociates");        
        action.setParams({ batchID : component.get("v.currentBatchID")});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(response.getState()==='SUCCESS'){
                component.set("v.associates",response.getReturnValue());
            }
        });       
        
        $A.enqueueAction(action);
        
    }
})