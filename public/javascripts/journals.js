/**
   Separate hournals namespace for journals specific scripting
 */
var journals = {

    validate: function ()
    {
	var sum1 = $('#dynfield_1_sum')[0].innerHTML;
	var sum2 = $('#dynfield_2_sum')[0].innerHTML;
	
	$('#dynfield_diff')[0].innerHTML = toMoney(parseFloatNazi(sum1)-parseFloatNazi(sum2));
	
	var ok = (parseFloatNazi(sum1)-parseFloatNazi(sum2))==0.0;
	if (ok) {
	    $('#journal_submit')[0].className = 'submit_ok';
	    $('#journal_submit')[0].disabled = false;
	} else {
	    $('#journal_submit')[0].className = 'submit_error';
	    $('#journal_submit')[0].disabled = true;
	}
	return sum1==sum2;
    },
    
    sumColumn: function (column)
    {
	var sum = 0.0;
	for (var i=0; i < LODO.journalLines; i++) {
	    
	    sum += parseFloatNazi($('#dynfield_' + column + '_' + i)[0].value);
	}
	
	$('#dynfield_' + column + '_sum')[0].innerHTML = toMoney(sum);
	
	journals.validate();
    },
    
    makeAccountSelect: function () {
	var sel = document.createElement("select");
	sel.name = "journal_operations[" + LODO.journalLines+"][account_id]";
	sel.id = "dynfield_0_"+ LODO.journalLines;
	
	for (var i=0; i<LODO.accountList.length; i++) {
	    sel.add(new Option("" + LODO.accountList[i].account.number + 
			       "-" +LODO.accountList[i].account.name,
			       LODO.accountList[i].account.id), null);
	}
	
	return sel;
    },

    doDisable: function (row_number)
    {
	var debet = $('#dynfield_1_' + row_number)[0];
	var credit = $('#dynfield_2_' + row_number)[0];
	
	credit.disabled=false;
	debet.disabled=false;
	
	if (parseFloatNazi(debet.value) > 0.0) {
	    credit.disabled=true;
	}
	else if (parseFloatNazi(credit.value) > 0.0) {
	    debet.disabled=true;
	}
	
    },

    makeDebet: function () {
	var res = document.createElement("input");
	res.type="text";
	res.name = "journal_operations[" + LODO.journalLines+"][debet]";
	res.id='dynfield_1_' + LODO.journalLines;
	res.setAttribute("autocomplete","off");
	
	var fun;
	eval("fun=function (event) {journals.handleArrowKeys(event,  1, " + LODO.journalLines + ");}");
	res.onkeypress=fun;
	
	var fun2;
	eval("fun2=function (event) {journals.doDisable(" + LODO.journalLines + ");journals.sumColumn(1);}");
	res.onkeyup = fun2;
	
	return res;
	
    },
    
    makeCredit: function () {
	var res = document.createElement("input");
	res.type="text";
	res.name = "journal_operations[" + LODO.journalLines+"][credit]";
	res.id='dynfield_2_' + LODO.journalLines;
	res.setAttribute("autocomplete","off");
	
	var fun;
	eval("fun=function (event) {journals.handleArrowKeys(event,  2, " + LODO.journalLines + ");}");
	res.onkeypress=fun;
	
	var fun2;
	eval("fun2=function (event) {journals.doDisable(" + LODO.journalLines + ");journals.sumColumn(2);}");
	res.onkeyup = fun2;
	
	return res;
    },
    
    makeText: function(id) {
	var res = document.createElement("span");
	res.id=id + "_" + LODO.journalLines;
	return res;
    },
    
    addAccountLine: function(line)
    {
	if(!LODO.journalLines) {
	    LODO.journalLines = 0;
	}
	
	var opTable = $('#operations')[0];
	
	var row = opTable.insertRow(opTable.rows.length);
	
	row.id='tjo';
	
	row.addCell = function (content) {
	    var c = row.insertCell(this.cells.length);
	    c.appendChild(content);
	}
	
	row.addCell(journals.makeAccountSelect());
	row.addCell(journals.makeDebet());
	row.addCell(journals.makeCredit());
	row.addCell(journals.makeText('balance'));
	row.addCell(journals.makeText('in'));
	row.addCell(journals.makeText('out'));
	row.addCell(journals.makeText('vat'));
	var cell = journals.makeText('amount');
	
	if (line) {
	    var line_id = document.createElement("input");
	    line_id.type = "hidden";
	    line_id.name = "journal_operations[" + LODO.journalLines+"][id]";
	    line_id.value = line.id;
	    cell.appendChild(line_id);
	}
	
	row.addCell(cell);
	
	
	if (line) {
	    amount = line.amount;
	    $("#dynfield_0_"+ LODO.journalLines)[0].value = line.account_id;
	    $("#dynfield_1_"+ LODO.journalLines)[0].value = amount<0?-amount:0;
	    $("#dynfield_2_"+ LODO.journalLines)[0].value = amount>0?amount:0;
	    journals.doDisable(LODO.journalLines);
	}
	LODO.journalLines++;
	stripe('#operations_table');
    },

    addPredefined: function(){
	lines = LODO.journalOperationList;
	for (var i=0; i<lines.length; i++) {
	    line = lines[i]['journal_operation'];
	    journals.addAccountLine(line);
	}
	journals.sumColumn(1);
	journals.sumColumn(2);
	journals.validate();
    },
    
    handleArrowKeys: function(evt, col_number, row_number) {
	evt = (evt) ? evt : ((window.event) ? event : null);
	if (evt) {
	    var el=null;
	    
	    switch (evt.keyCode) {
	    case 37:
		/*
		  left
		*/
		col_number--;
		break;    
		
	    case 38:
		/*
		  up
		*/
		row_number--;
		break;    
		
	    case 39:
		/*
		  right
		*/
		col_number++;
		break;    
		
	    case 40:
		/*
		  down
	    */
		row_number++;
		break;
		
	    }
	    
	    el = $('#dynfield_' + col_number+'_' +row_number)[0];
	    
	    if (el) {
		el.focus();
	    }
	}
    }
    
}