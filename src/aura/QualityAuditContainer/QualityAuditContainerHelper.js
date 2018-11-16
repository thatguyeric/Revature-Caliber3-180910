({
	updateTheBatchID : function(component, event, helper){
        var tempv = event.getParam("currentBatchID");
        component.set("v.currentBatchID", tempv);
        console.log('we are updating the batchID~! id= '+ tempv);
    }
})