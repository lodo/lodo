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

    getAccount: function (id) {
	for( var i =0; i<LODO.accountList.length; i++) {
	    if (LODO.accountList[i].account.id == id) {
		return LODO.accountList[i].account;
	    }
	}
	return null;
    },
    
    sumColumn: function (column)
    {
	var sum = 0.0;
	for (var i=0; i < LODO.journalLines; i++) {
	    sum += parseFloatNazi($('#dynfield_' + column + '_' + i)[0].value);
	}
	
	$('#dynfield_' + column + '_sum')[0].innerHTML = toMoney(sum);
	
    },
    
    update: function ()
    {
	journals.sumColumn(1);
	journals.sumColumn(2);
	for (var i=0; i < LODO.journalLines; i++) {
	    var account = journals.getAccount($('#dynfield_0_'+i)[0].value);
	    var vat_account = account.vat_account.target_account;
	    
	    $('#vat1_account_'+i)[0].innerHTML = journals.getAccount($('#dynfield_0_'+i)[0].value).name;
	    $('#vat2_account_'+i)[0].innerHTML = vat_account.name;
	    
	    var debet = parseFloatNazi($('#dynfield_2_' + i)[0].value);
	    var credit = parseFloatNazi($('#dynfield_1_' + i)[0].value);
	    var debet1 = $('#vat1_debet_'+i)[0];
	    var debet2 = $('#vat2_debet_'+i)[0];
	    var credit1 = $('#vat1_credit_'+i)[0];
	    var credit2 = $('#vat2_credit_'+i)[0];
	    credit1.innerHTML =debet1.innerHTML =credit2.innerHTML =debet2.innerHTML ='';
	    
	    var vatFactorInput = $('#vatFactor_'+i)[0];
	    var overridable = vat_account.overridable || account.vat_overridable;
	    
	    vatFactorInput.readOnly=!overridable;
	    
	    var vatFactor = 0.01*parseFloatNazi(vatFactorInput.value);
	    var baseAmount = (credit > 0.0)?credit:debet;
	    var vatAmount = toMoney(vatFactor * baseAmount);


	    var vatAccountInput = $('#vat_account_'+i)[0];
	    vatAccountInput.value = account.vat_account.id;
	    
	    if (credit > 0) {
		debet1.innerHTML = vatAmount;
		credit2.innerHTML = vatAmount;
	    } else {
		debet2.innerHTML = vatAmount;
		credit1.innerHTML = vatAmount;
	    }
	}
	
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
	var line = LODO.journalLines;
	sel.onchange= function(){
	    journals.setDefaultVat(line);
	    journals.update();
	}
	
	return sel;
    },

    setDefaultVat: function (line) 
    {
	var account = journals.getAccount($('#dynfield_0_'+line)[0].value);
	
	$('#vatFactor_'+line)[0].value = account.vat_account.percentage;

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
	eval("fun2=function (event) {journals.doDisable(" + LODO.journalLines + ");journals.update();}");
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
	eval("fun2=function (event) {journals.doDisable(" + LODO.journalLines + ");journals.update();}");
	res.onkeyup = fun2;
	
	return res;
    },
    
    makeVat: function (val) {
	var res = document.createElement("input");
	res.type="text";
	res.name = "journal_operations[" + LODO.journalLines+"][vat]";
	res.id='vatFactor_' + LODO.journalLines;
	res.value = val;

	res.onkeyup = journals.update;
	
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
	row.addCell = function (content) {
	    var c = this.insertCell(this.cells.length);
	    c.appendChild(content);
	}

	var row2 = opTable.insertRow(opTable.rows.length);
	row2.addCell = function (content) {
	    var c = this.insertCell(this.cells.length);
	    c.appendChild(content);
	}
	
	var row3 = opTable.insertRow(opTable.rows.length);
	row3.addCell = function (content) {
	    var c = this.insertCell(this.cells.length);
	    c.appendChild(content);
	}
	
	row2.className="vat1";
	row2.addCell(journals.makeText('vat1_account'));
	row2.addCell(journals.makeText('vat1_debet'));
	row2.addCell(journals.makeText('vat1_credit'));
	
	row3.className="vat2";
	row3.addCell(journals.makeText('vat2_account'));
	row3.addCell(journals.makeText('vat2_debet'));
	row3.addCell(journals.makeText('vat2_credit'));
	
	row.addCell(journals.makeAccountSelect());
	row.addCell(journals.makeDebet());
	row.addCell(journals.makeCredit());
	row.addCell(journals.makeText('balance'));
	row.addCell(journals.makeText('in'));
	row.addCell(journals.makeText('out'));
	row.addCell(journals.makeVat(line?line.vat:25));
	var cell = journals.makeText('amount');
	
	if (line) {
	    var line_id = document.createElement("input");
	    line_id.type = "hidden";
	    line_id.name = "journal_operations[" + LODO.journalLines+"][id]";
	    line_id.value = line.id;
	    cell.appendChild(line_id);
	}
	var vat_account_id = document.createElement("input");
	vat_account_id.type = "hidden";
	vat_account_id.name = "journal_operations[" + LODO.journalLines+"][vat_account_id]";
	vat_account_id.id = "vat_account_" + LODO.journalLines;
	
	cell.appendChild(vat_account_id);
	
	
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
	if (!line) 
	{
	    journals.update();
	}
	
    },

    addPredefined: function(){
	lines = LODO.journalOperationList;
	for (var i=0; i<lines.length; i++) {
	    line = lines[i]['journal_operation'];
	    journals.addAccountLine(line);
	}
	journals.update();
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