({
    onWorkAccepted : function(component, event, helper) {
        console.log("Work accepted.");
        var workItemId = event.getParam('workItemId');
        var workId = event.getParam('workId');
        console.log('workItemId = ' + workItemId);

        component.find('myConversation').handleWorkAccepted(workItemId);

    }, 
})