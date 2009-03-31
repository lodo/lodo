var bills = {

    getOrderPrice: function(id) 
    {
	
	for (var i=0; i<LODO.orderList.length; i++) {
	    if (LODO.orderList[i].order.id == id) 
		{
		    return LODO.orderList[i].order.price;
		}
		
	}
	return 0.0;
    },

    validate: function()
    {
	for (var i=0; i < LODO.orderLines; i++) {
	    var price = $('#unitPrice_' + i)[0];
	    var orderId = $('#order_id_' + i)[0].value;
		
	    price.innerHTML = toMoney(bills.getOrderPrice(orderId));
	}
	bills.sumColumn();
    },

    sumColumn: function()
    {
	var sum = 0.0;
	for (var i=0; i < LODO.orderLines; i++) {
	    var val = parseFloatNazi($('#unitPrice_'+i)[0].innerHTML)* (100.0-parseFloatNazi($('#discount_'+i)[0].value))*0.01;
	    sum += val;
	    bills.setPrice(i,val);
	}
	
	bills.setTotalPrice(sum);
    },

    makeOrderSelect: function(value) {
	var sel = document.createElement("select");
	sel.name = "orders[" + LODO.orderLines+"][order_id]";
	sel.id = "order_id_"+ LODO.orderLines;
        sel.line_id = LODO.orderLines;

        for (var i=0; i<LODO.orderList.length; i++) {
	    sel.add(new Option("" + LODO.orderList[i].order.customer.name + " - " + LODO.orderList[i].order.order_date + " - #" + LODO.orderList[i].order.id,
                               LODO.orderList[i].order.id), null);
	}

	sel.onchange = function (event) {
            $.each(
                LODO.orderList[this.value].order.order_items,
                function (order_item) {
                    bills.addProduct($("#orderDetails_" + this.line_id), {amount: 0, discount: 0.0, order_item: order_item});
                }
            )
        }
	sel.value = value;

	return sel;
    },

    makeDiscount: function (value) {
	var res = document.createElement("input");
	res.type="text";
	res.id='discount_' + LODO.orderLines;
	res.setAttribute("autocomplete","off");
	
	res.onkeyup = function (event) {bills.validate();}
	res.value = value;
	return res;
    },
    
    makePrice: function (value) {
	
	var res = document.createElement("span");

	var inp = document.createElement("input");
	inp.type="hidden";
	inp.id='price_' + LODO.orderLines;
	inp.name = "orders[" + LODO.orderLines+"][price]";
	inp.value = value;
	res.appendChild(inp);
	res.appendChild(bills.makeText('priceLabel'));
	return res;
    },

    setTotalPrice: function(price) {
	price = price*(100.0-parseFloatNazi($('#discount_total')[0].value))*0.01;
	$('#dynfield_sum')[0].innerHTML = toMoney(price);
	$('#price')[0].value = toMoney(price);
    },

    setPrice: function(line, value) {
	$('#price_'+line)[0].value = toMoney(value);
	$('#priceLabel_'+line)[0].innerHTML = toMoney(value);
    },

    makeText: function(id) {
	var res = document.createElement("span");
	res.id=id + "_" + LODO.orderLines;
	return res;
    },

    makeOrderDetails: function(lines) {
	var res = makeTemplateInstance("orderDetails_" + LODO.orderLines, "order_template")
	if (lines != undefined)
            lines.each(function (line) {
                bills.addProduct(res, line)
            })
        return res;
    },

    addOrder: function(line)
    {
	if(!LODO.orderLines) {
	    LODO.orderLines = 0;
	}

	var opTable = $('#orders')[0];
	
	var row = opTable.insertRow(opTable.rows.length);
    
	row.addCell = function (content) {
	    var c = row.insertCell(this.cells.length);
	    c.appendChild(content);
	}
    
	row.addCell(bills.makeOrderSelect(line?line.order_id:null));
	row.addCell(bills.makeOrderDetails(line?line.order_details:null));
	
	var cell = document.createElement("span");
	/*
	  If we are reediting an old line, insert the id so we can match them together
	*/
	if (line) {
	    var line_id = document.createElement("input");
	    line_id.type = "hidden";
	    line_id.name = "orders[" + LODO.orderLines+"][id]";
	    line_id.value = line.id;
	    cell.appendChild(line_id);
	}

	row.addCell(cell);
	
	LODO.orderLines++;
	stripe();
	bills.validate();
    },

    addPredefined: function(){
	lines = LODO.billItemList;
	for (var i=0; i<lines.length; i++) {
	    line = lines[i]['bill_item'];
	    bills.addOrder(line);
	}
    }

}
