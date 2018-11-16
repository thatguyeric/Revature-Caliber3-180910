({
    handleClickHomeLogo: function (cmp, event) {
        // redirct to the home page
 
    },
    
    settingsHandleChange : function (cmp, event, helper) {
        // go to the corresponding settings page
		// most likely, this will remain empty for now
    },
    
    toQualityAudit: function (cmp, event) {
        window.location.href = "https://sf-caliber-dev-ed.lightning.force.com/lightning/n/Quality_Audit";
    },
    
    toReports: function (cmp, event) {
        window.location.href = "https://sf-caliber-dev-ed.lightning.force.com/lightning/n/Caliber_Reports";
    },
    
    toAssessBatch: function (cmp, event) {
        window.location.href = "https://sf-caliber-dev-ed.lightning.force.com/lightning/n/Assess_Batch";
    },
    
    handleClick: function (cmp, event) {
        
    }
})