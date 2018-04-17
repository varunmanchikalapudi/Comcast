({    
    doInit : function(component, event, helper) {      
    },
    closeModal:function(component,event,helper){ 
        
        if (confirm('Are you sure you want to close SQO Session')) {
            var cmpTarget = component.find('Modalbox');
            var cmpBack = component.find('Modalbackdrop');
            $A.util.removeClass(cmpBack,'slds-backdrop--open');
            $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
            component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5}.forceStyle.desktop .viewport{overflow:visible}");
            $A.get('e.force:refreshView').fire();
        } else {
            // Do nothing!
        }
    },
    
    openmodal: function(component,event,helper) {
        
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:-19}.forceStyle.desktop .viewport{overflow:visible}");
        document.body.setAttribute('style', 'overflow: visible;');
        component.set("v.cssStyle", ".slds-modal_container{padding:14rem 0}");
        var action = component.get("c.getOpportunityLst");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                  console.log("From server: " + response.getReturnValue());
                component.set("v.OppJSONPeram", response.getReturnValue());    
                $A.createComponent("force:canvasApp",                                 
                                   {                                       
                                       "developerName":"Amdocs",//"Amdocs",
                                       //"canvasId":"sfdc_comcast_b2b_canvas", //"Amdocs",
                                       "width":"1024 px",                     
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
        $A.get('e.force:refreshView').fire();}
})