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
	for (var i=0; i < $('#bill')[0].table_lines; i++) {
	    var price = $('#unitPrice_' + i)[0];
	    var orderId = $('#order_id_' + i)[0].value;
		
	    price.innerHTML = toMoney(bills.getOrderPrice(orderId));
	}
	bills.sumColumn();
    },

    sumColumn: function()
    {
	var sum = 0.0;
	for (var i=0; i < $('#bill')[0].table_lines; i++) {
	    var val = parseFloatNazi($('#unitPrice_'+i)[0].innerHTML)* (100.0-parseFloatNazi($('#discount_'+i)[0].value))*0.01;
	    sum += val;
	    bills.setPrice(i,val);
	}
	
	bills.setTotalPrice(sum);
    },

    makeOrderSelect: function(value) {
	var sel = document.createElement("select");
	sel.name = "orders[" + $('#bill')[0].table_lines+"][order_id]";
	sel.id = "order_id_"+ $('#bill')[0].table_lines;
        sel.line_id = $('#bill')[0].table_lines;

        for (var i=0; i<LODO.orderList.length; i++) {
	    sel.add(new Option("" + LODO.orderList[i].order.customer.name + " - " + LODO.orderList[i].order.order_date + " - #" + LODO.orderList[i].order.id,
                               i), null);
	}

	sel.onchange = function (event) {
            $.each(
                LODO.orderList[this.value].order.order_items,
                function (order_item) {
                    bills.addProduct($("#order_details_" + this.line_id), {price: 0, amount: 0, discount: 0.0, order_item: order_item});
                }
            )
        }
	sel.value = value;

	return sel;
    },

    makeDiscount: function (value) {
	var res = document.createElement("input");
	res.type="text";
	res.id='discount_' + $('#bill')[0].table_lines;
	res.setAttribute("autocomplete","off");
	
	res.onkeyup = function (event) {bills.validate();}
	res.value = value;
	return res;
    },
    
    makePrice: function (value) {
	
	var res = document.createElement("span");

	var inp = document.createElement("input");
	inp.type="hidden";
	inp.id='price_' + $('#bill')[0].table_lines;
	inp.name = "orders[" + $('#bill')[0].table_lines+"][price]";
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

    makeText: function(id, text, context) {
	var res = document.createElement("span");
	res.id=id + "_" + $(context)[0].table_lines;
        if (text) {
          $(res).html(text);
        }
	return res;
    },

    makeOrderDetails: function(lines) {
	var res = makeTemplateInstance("order_details_" + $('#bill')[0].table_lines, "order_template")
	
	res.updateProducts = function (order_nr) {
            this.discount = LODO.orderList[order_nr].order.price / sum(map(function (x) { return x.price; }, LODO.orderList[order_nr].order.order_items));

            $.each(
                LODO.orderList[order_nr].order.order_items,
                function (order_item) {
                    bills.addProduct(this, {price: LODO.orderList[order_nr].order.price * discount, amount: 0, discount: 0.0, order_item: order_item});
                }
            )

        }
        res.productLines = 0;
        return res;
    },

    addCell: function (row, content) {
	var c = row.insertCell(row.cells.length);
	c.appendChild(content);
        return c;
    },

    addProduct: function (order_details, line) {
        // bills.addProduct($("#order_details_" + this.line_id), {amount: 0, discount: 0.0, order_item: order_item});

        var opTable = $("#" + order_details.getAttribute('id') + "_products", order_details)[0];
	var row = opTable.insertRow(opTable.rows.length);
    
	bills.addCell(row, bills.makeText('product', line.order_item.product.name, opTable));
	bills.addCell(row, bills.makeText('unit_price', line.price, opTable));
	bills.addCell(row, bills.makeText('remaining', line.order_item.amount, opTable));

/*
	<th>Product</th>
	<th>Unit Price</th>
	<th>Remaining</th>
	<th>Amount</th>
	<th>Discount</th>
	<th>Total Price</th>
*/

	order_details.productLines++;
	stripe();
	bills.validate();
   },

    addOrder: function(line)
    {
	if(!$('#bill')[0].table_lines) {
	    $('#bill')[0].table_lines = 0;
	}

	var opTable = $('#orders')[0];
	var row = opTable.insertRow(opTable.rows.length);
    
	bills.addCell(row, bills.makeOrderSelect(line?line.order_id:null));
	var cell = bills.addCell(row, bills.makeOrderDetails(line?line.order_details:null));
	/*
	  If we are reediting an old line, insert the id so we can match them together
	*/
	if (line) {
	    var line_id = document.createElement("input");
	    line_id.type = "hidden";
	    line_id.name = "orders[" + $('#bill')[0].table_lines+"][id]";
	    line_id.value = line.id;
	    cell.appendChild(line_id);
	}
	
	$('#bill')[0].table_lines++;
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
