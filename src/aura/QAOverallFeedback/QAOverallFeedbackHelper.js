({
    //Sets smile to green and others to default gray
    setSmileColor : function(component){
    	component.set("v.smileyColor","fa fa-smile-o fa-2x smilePicked");
        component.set("v.neutralColor","fa fa-meh-o fa-2x");
        component.set("v.sadyColor","fa fa-frown-o fa-2x");
	},
    //Sets meh to yellow and others to default gray
    setNeutralColor : function(component){
        component.set("v.smileyColor","fa fa-smile-o fa-2x");
        component.set("v.neutralColor","fa fa-meh-o fa-2x neutralPicked");
        component.set("v.sadyColor","fa fa-frown-o fa-2x");
    },
    //Sets sad to red and others to default gray
    setSadColor : function(component){
        component.set("v.smileyColor","fa fa-smile-o fa-2x");
        component.set("v.neutralColor","fa fa-meh-o fa-2x");
        component.set("v.sadyColor","fa fa-frown-o fa-2x sadPicked");
    }
})