function startswith (str, prefix) {
  return str.substring(0,prefix.length) == prefix;
}

function endswith (str, suffix) {
  return str.substring(this.length - suffix.length) == suffix;
}


function replaceIdsInDOM(id, templateId, dom) {
    $.each(dom, function () {
	if (this.nodeType == 1) {  // Node.ELEMENT_TYPE
	    if (   this.hasAttribute('id')
		&& startswith(this.getAttribute('id'), templateId))
		this.setAttribute('id', id + this.getAttribute('id').substring(templateId.length))
	    if (   this.hasAttribute('name')
		&& startswith(this.getAttribute('name'), templateId))
		this.setAttribute('name', id + this.getAttribute('name').substring(templateId.length))
	}
    })
    if (dom.children().length > 0)
        replaceIdsInDOM(id, templateId, dom.children());
}

function makeTemplateInstance(id, templateId) {
    var res = $('#' + templateId).clone(true);
    replaceIdsInDOM(id, templateId, res);
    res[0].style.display = 'inherit';
    return res[0];
}

function parseFloatNazi(str) 
{
    if (str == null || str == "") {
	return 0;
    }

    var str2 = str.replace(/,/g,'.');

    if (str2.match(/^[0-9]*\.?[0-9]+$/))
	return parseFloat(str2);
    return NaN;
}

function toMoney (val) {
    if (isNaN(val)) {
	return '?';
    }
    return val.toFixed(2).replace(/\./g,',');
}


// this function is needed to work around 
// a bug in IE related to element attributes
function hasClass(obj) {
    var result = false;
    if (obj.getAttributeNode("class") != null) {
	result = obj.getAttributeNode("class").value;
    }
    return result;
}   

function stripe(id) {
		
    // the flag we'll use to keep track of 
    // whether the current row is odd or even
    var even = false;
		
    // obtain a reference to the desired tables
    // ... and iterate through them
    var table_list;
    if (id != null) {
	table_list = $(id);
    } else {
	table_list = $('.striped');
    }
    
    for(var tab=0; tab<table_list.length;tab++) {
		
	var table = table_list[tab];
	if (! table) { continue; }
		    
	// by definition, tables can have more than one tbody
	// element, so we'll have to get the list of child
	// &lt;tbody&gt;s 
	var tbodies = table.getElementsByTagName("tbody");
		    
	// and iterate through them...
	for (var h = 0; h < tbodies.length; h++) {
			
	    // find all the &lt;tr&gt; elements... 
	    var trs = tbodies[h].getElementsByTagName("tr");
			
	    // ... and iterate through them
	    for (var i = 0; i < trs.length; i++) {

		var parent = trs[i].parentNode;
		while(parent && parent.nodeName.toLowerCase() != 'tbody') 
		    {
			parent = parent.parentNode;
		    }
	
		if( parent != tbodies[h] ) 
		    {
			continue;
		    }
				
		    
		// avoid rows that have a class attribute
		// or backgroundColor style
		if (! hasClass(trs[i]) &&
		    ! trs[i].style.backgroundColor) {
 		  
		    // get all the cells in this row...
		    var tds = trs[i].getElementsByTagName("td");
		    var ths = trs[i].getElementsByTagName("th");
		    
		    // and iterate through them...
		    for (var j = 0; j < tds.length; j++) {
			
			var mytd = tds[j];
			
			mytd.className = even?'even':'odd';
		    }
		    for (var j = 0; j < ths.length; j++) {
			
			var myth = ths[j];
			
			myth.className = even?'even':'odd';
		    }
		}
		// flip from odd to even, or vice-versa
		even =  ! even;
	    }
	}
    }
}
