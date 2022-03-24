({
    saveItem: function(component, item, callback) {  //здесь не вызывается из-за бага Trailhead
        let action = component.get("c.saveItem");
        action.setParams({
            "item": item
        });
        if (callback) {
            action.setCallback(this, callback);
        }
        $A.enqueueAction(action);
    },    
    createItem: function(component, item) {			// здесь не вызывается из-за бага Trailhead
        this.saveItem(component, item, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                let items = component.get("v.items");
                items.push(response.getReturnValue());
                component.set("v.items", items);
            }
        });
    },
    updateItem: function(component, item) {
        this.saveItem(component, item);
    },
})