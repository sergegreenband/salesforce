({
        // Load expenses from Salesforce
    doInit: function(component, event, helper) {
        // Create the action
        let action = component.get("c.getExpenses");
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.expenses", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
        handleCreateExpense: function(component, event, helper) {
        let newExpense = event.getParam("expense");
        helper.createExpense(component, newExpense);
    },
        handleUpdateExpense: function(component, event, helper) {
        let updatedExp = event.getParam("expense");
        helper.updateExpense(component, updatedExp);
    }
})