function frxOpenPrint(url) {
  window.open(url, '_blank','resizable,scrollbars,width="400",height="300"'); 
};

function frRequestObject() {
  if (typeof XMLHttpRequest === 'undefined') {
    XMLHttpRequest = function() {
      try { return new ActiveXObject("Msxml2.XMLHTTP.6.0"); }
        catch(e) {}
      try { return new ActiveXObject("Msxml2.XMLHTTP.3.0"); }
        catch(e) {}
      try { return new ActiveXObject("Msxml2.XMLHTTP"); }
        catch(e) {}
      try { return new ActiveXObject("Microsoft.XMLHTTP"); }
        catch(e) {}
      throw new Error("This browser does not support XMLHttpRequest.");
    };
  }
  return new XMLHttpRequest();
}

function frRequestServer(url) {
    req = frRequestObject();
//    req.open("GET", url + "&seed=" + Math.random(), true);
    req.open("GET", url, true);
    req.onreadystatechange = frProcessReqChange;
    req.setRequestHeader("If-Modified-Since", "Sat, 1 Jan 1991 00:00:00 GMT");
    req.send(null);
}

function frReplaceInnerHTML(repobj, html) {
    var obj = repobj;
    var newObj = document.createElement(obj.nodeName);
    newObj.id = obj.id;
    newObj.className = obj.className;
    newObj.innerHTML = html;
    if (obj.parentNode)
        obj.parentNode.replaceChild(newObj, obj);
    else
        obj.innerHTML = html;
    return newObj;
}

function frProcessReqChange() {
  try 
  { 
    if (req.readyState == 4) 
    {
        if (req.status == 200) 
        {
            obj = req.getResponseHeader("FastReport-container");
	    div = document.getElementById(obj);
            div = frReplaceInnerHTML(div, req.responseText);	        
            var scripts = div.getElementsByTagName('script');
            for (var i = 0; i < scripts.length; i++) 
                eval(scripts[i].text);
        } 
        else 
        {
            alert("Error:" + req.statusText + " " + req.status);
        }
    }
  }
  catch( e ) {
	alert(e);
  }
}
