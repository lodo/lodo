
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

function validate()
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
}

function sumColumn(column)
{
    var sum = 0.0;
    for (var i=0; i < LODO.journalLines; i++) {

	sum += parseFloatNazi($('#dynfield_' + column + '_' + i)[0].value);
    }

    $('#dynfield_' + column + '_sum')[0].innerHTML = toMoney(sum);

    validate();
}

function makeAccountSelect() {
    var sel = document.createElement("select");
    sel.name = "account_" + LODO.journalLines;
    sel.id = "dynfield_0_"+ LODO.journalLines;
    
    for (var i=0; i<LODO.accountList.length; i++) {
	sel.add(new Option("" + LODO.accountList[i].account.number + "-" +LODO.accountList[i].account.name, LODO.accountList[i].account.id), null);
    }

    return sel;
}

function doDisable(row_number)
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

}

function makeDebet() {
    var res = document.createElement("input");
    res.type="text";
    res.name = "debet_" + LODO.journalLines;
    res.id='dynfield_1_' + LODO.journalLines;
    res.setAttribute("autocomplete","off");

    var fun;
    eval("fun=function (event) {handleArrowKeys(event,  1, " + LODO.journalLines + ");}");
    res.onkeypress=fun;

    var fun2;
    eval("fun2=function (event) {doDisable(" + LODO.journalLines + ");sumColumn(1);}");
    res.onkeyup = fun2;

    return res;

}

function makeKredit() {
    var res = document.createElement("input");
    res.type="text";
    res.name = "dynfield_2_" + LODO.journalLines;
    res.id=res.name;
    res.setAttribute("autocomplete","off");

    var fun;
    eval("fun=function (event) {handleArrowKeys(event,  2, " + LODO.journalLines + ");}");
    res.onkeypress=fun;

    var fun2;
    eval("fun2=function (event) {doDisable(" + LODO.journalLines + ");sumColumn(2);}");
    res.onkeyup = fun2;

    return res;
}

function makeText(id) {
    var res = document.createElement("span");
    res.id=id + "_" + LODO.journalLines;
    return res;
}

function addAccountLine()
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
    
    row.addCell(makeAccountSelect());
    row.addCell(makeDebet());
    row.addCell(makeKredit());
    row.addCell(makeText('balance'));
    row.addCell(makeText('in'));
    row.addCell(makeText('out'));
    row.addCell(makeText('vat'));
    row.addCell(makeText('amount'));
    
    LODO.journalLines++;
    stripe('#operations_table');
}

function handleArrowKeys(evt, col_number, row_number) {
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

