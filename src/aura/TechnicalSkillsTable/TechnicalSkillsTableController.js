({
    handleReportFilterChange : function(component, event, helper) {
        helper.getCurrentBatch(component, event, helper);
        helper.getBatchCat(component, event, helper);
        /*var data = component.get("v.serverResponseData");
        for (let i = 0; i < data.batch.categories.length; i++){
            data.batch.categories[i].grade = data.batch.categories[i].grade.toFixed(2);
        }
        component.set("v.batchData", data); */
    }
})