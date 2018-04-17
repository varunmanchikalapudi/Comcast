({
    
    doInit : function(component, event, helper) {
        var action = component.get("c.getProposalRecs");        
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {   
                 console.log("From server: " + response.getReturnValue());
                $A.createComponent("force:canvasApp",                                 
                                   {                                       
                                       "developerName":"Amdocs", //"Amdocs",
                                      // "canvasId":"Amdocs", //"sfdc_comcast_b2b_canvas",
                                       "width":"100%",                     
                                       "parameters": response.getReturnValue()
                                   },
                                   function(CanvasApp) {
                                       var canvasAppContainer = component.find("amdocsAppDiv");  
                                       canvasAppContainer.set("v.body",CanvasApp);                                       
                                   }
                                  )
            }
        });       
        $A.enqueueAction(action);   
    }  
})