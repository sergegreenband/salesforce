({
    packItem: function(component, event, helper) {
        let item = component.get("v.item");
        let updateEvent = component.getEvent("updateItem");
        updateEvent.setParams({ "item": item });
        updateEvent.fire();
    }
})