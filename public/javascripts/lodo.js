


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
