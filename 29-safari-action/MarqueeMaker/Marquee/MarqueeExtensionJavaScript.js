
function TagContentWrapper() {
  var self = this;
  
  var wrapContentOfElement = function(element, wrapper) {
    wrapper.innerHTML = element.innerHTML;
    element.innerHTML = wrapper.outerHTML;
  }
  
  this.wrapContentOfTags = function(type, wrapperCreator) {
    var allElements = document.getElementsByTagName(type);
    for (var i = 0; i < allElements.length; ++i) {
      wrapContentOfElement(allElements[i], wrapperCreator());
    }
  };
  
  this.wrapContentOfTagList = function(typeList, wrapperCreator) {
    typeList.forEach(function(type){
      self.wrapContentOfTags(type, wrapperCreator);
    });
  };
}

var tagContentWrapper = new TagContentWrapper;

var marqueeWrapper = function(typeList) {
  tagContentWrapper.wrapContentOfTagList(typeList, function() {
    return document.createElement("marquee");
  });
}


/* The Extension Code for use with the iOS Action Extension */
var MarqueeMakerExtension = function() {};

MarqueeMakerExtension.prototype = {
  run: function(arguments) {
    arguments.completionFunction({"baseURI" : document.baseURI});
  },
    
  finalize: function(arguments) {
    marqueeWrapper(arguments["marqueeTagNames"]);
  }
}

var ExtensionPreprocessingJS = new MarqueeMakerExtension;
