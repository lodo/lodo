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
/*
	for (var i=0; i < $('#bill')[0].table_lines; i++) {
	    var price = $('#unitPrice_' + i)[0];
	    var orderId = $('#order_id_' + i)[0].value;
		
	    price.innerHTML = toMoney(bills.getOrderPrice(orderId));
	}
	bills.sumColumn();
*/
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

    setTotalPrice: function(price) {
	price = price*(100.0-parseFloatNazi($('#discount_total')[0].value))*0.01;
	$('#dynfield_sum')[0].innerHTML = toMoney(price);
	$('#price')[0].value = toMoney(price);
    },

    setPrice: function(line, value) {
	$('#price_'+line)[0].value = toMoney(value);
	$('#priceLabel_'+line)[0].innerHTML = toMoney(value);
    },




/* MY CODE */
    getCurrentLineId: function (context) {
        var ctx = $(context);
        return ctx[0].getAttribute('id') + "_" + (ctx[0].table_lines-1);
    },

    getCurrentLineName: function (context) {
        var ctx = $(context);
        return ctx[0].name + "[" + (ctx[0].table_lines-1) + "]";
    },

    addLine: function (context) {
        var ctx = $(context);
        var rows = bills.getRowList(ctx);

        ctx[0].table_lines++;
	return rows.insertRow(rows.rows.length);
    },

    getRowList: function (context) {
        var ctx = $(context);
        return $i(ctx[0].getAttribute('id') + '_rows', ctx)[0];
    },



    makeDiscount: function (value, context) {
	var res = document.createElement("input");
	res.type = "text";
	res.id = bills.getCurrentLineId(context) + '_discount';
	res.name = bills.getCurrentLineName(context) + '[discount]';
	res.setAttribute("autocomplete","off");
	
	res.onkeyup = function (event) {bills.validate();}
	res.value = value;
	return res;
    },
    
    makePrice: function (value, context) {	
	var res = document.createElement("span");

	var inp = document.createElement("input");
	inp.type = "hidden";
	inp.id = bills.getCurrentLineId(context) + '_price';
	inp.name = bills.getCurrentLineId(context) + '[price]';
	inp.value = value;
	res.appendChild(inp);
	res.appendChild(bills.makeText('priceLabel'));
	return res;
    },

    makeText: function(id, text, context) {
	var res = document.createElement("span");
	res.id = bills.getCurrentLineId(context) + '_' + id;
        if (text)
          $(res).html(text);
	return res;
    },

    addCell: function (row, content) {
	var c = row.insertCell(row.cells.length);
	c.appendChild(content);
        return c;
    },


    addProduct: function (line, context) {
	var row = bills.addLine(context);
    
	bills.addCell(row, bills.makeText('product', line.order_item.product.name, context));
	bills.addCell(row, bills.makeText('unit_price', line.price, context));
	bills.addCell(row, bills.makeText('remaining', line.order_item.amount, context));
	bills.addCell(row, bills.makeText('amount', line.order_item.amount, context));
	bills.addCell(row, bills.makeDiscount(line.order_item.amount, context));
	bills.addCell(row, bills.makeText('price', 4711, context));
	stripe();
	bills.validate();
   },

    makeOrderSelect: function(value) {
	var sel = document.createElement("select");
	sel.id = bills.getCurrentLineId('#bill') + "_order_id";
	sel.name = bills.getCurrentLineName('#bill') + "[order_id]";
        sel.line_id = bills.getCurrentLineId('#bill')

        for (var i=0; i<LODO.orderList.length; i++) {
	    sel.add(new Option("" + LODO.orderList[i].order.customer.name + " - " + LODO.orderList[i].order.order_date + " - #" + LODO.orderList[i].order.id,
                               i), null);
	}

	sel.onchange = function (event) {
            $i(sel.line_id + "_details")[0].updateProducts(this.value);
        }
	sel.value = value;

	return sel;
    },

    makeOrderDetails: function(lines) {
        console.log(bills.getCurrentLineId('#bill') + "_details");
        console.log(bills.getCurrentLineName('#bill') + "[details]");

	var res = makeTemplateInstance(
            bills.getCurrentLineId('#bill') + "_details",
            bills.getCurrentLineName('#bill') + "[details]",
            "order_template");
        console.log(res);

	res.updateProducts = function (order_nr) {
            console.log("updateProducts", order_nr, LODO.orderList[order_nr].order.order_items);
            res.discount = LODO.orderList[order_nr].order.price / sum(map(function (x) { return x.price; }, LODO.orderList[order_nr].order.order_items));
            res.table_lines = 0;

            var rows = bills.getRowList(res);
            while (rows.rows.length)
                rows.deleteRow(0);

            $.each(
                LODO.orderList[order_nr].order.order_items,
                function (order_item) {
                    console.log("addProduct", order_item, LODO.orderList[order_nr].order.order_items[order_item]);
                    bills.addProduct(
                        {price: LODO.orderList[order_nr].order.price * this.discount,
                         amount: 0,
                         discount: 0.0,
                         order_item: LODO.orderList[order_nr].order.order_items[order_item]},
                        res);
                })
        }
        return res;
    },

    addOrder: function(line) {
	var row = bills.addLine('#bill');
    
        var select = bills.makeOrderSelect(line?line.order_id:null);
	bills.addCell(row, select);
	var cell = bills.addCell(row, bills.makeOrderDetails(line?line.order_details:null));
        select.onchange();

	/* If we are reediting an old line, insert the id so we can match them together */
	if (line) {
	    var line_id = document.createElement("input");
	    line_id.type = "hidden";
	    line_id.name = bills.getCurrentLineName('#bill') + "[id]";
	    line_id.value = line.id;
	    cell.appendChild(line_id);
	}

	stripe();
	bills.validate();
    },

    addPredefined: function() {
	$('#bill')[0].table_lines = 0;
	$('#bill')[0].name = 'bill';
/*
	lines = LODO.billItemList;
	for (var i=0; i<lines.length; i++) {
	    line = lines[i]['bill_item'];
	    bills.addOrder(line);
	}
*/
    }

}
