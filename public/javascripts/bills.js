var bills = {
    validate: function() {
       bills.getRowList('#bill')
       bills.eachLine('#bill', '_details', bills.sumDetailsColumn);
       bills.sumColumn('#bill');
    },

    sumDetailsColumn: function(context) {
        bills.sumGenericColumn("_unit_price", "_discount", "", context);
    },

    sumColumn: function(context) {
        bills.sumGenericColumn("_price_label", "_discount", "_details", context);
    },

    sumGenericColumn: function(unit_price, discount, row_prefix, context) {
	var sum = 0.0;
        var id = $(context)[0].id;
	for (var i=0; i < $(context)[0].table_lines; i++) {
	    var val = (  parseFloatNazi($i(id + "_" + i + row_prefix + unit_price)[0].innerHTML)
                       * parseFloatNazi($i(id + "_" + i + row_prefix + "_amount")[0].value)
                       * (100.0-parseFloatNazi($i(id + "_" + i + row_prefix + discount)[0].value))
                       * 0.01);
	    sum += val;
	    bills.setPrice(i, val, row_prefix, context);
	}
	
	bills.setTotalPrice(sum, context);
    },

    setPrice: function(line, value, row_prefix, context) {
        var id = $(context)[0].id;
	$i(id + "_" + line + row_prefix + '_price')[0].value = toMoney(value);
	$i(id + "_" + line + row_prefix + '_price_label')[0].innerHTML = toMoney(value);
    },

    setTotalPrice: function(price, context) {
        var id = $(context)[0].id;
	price = price*(100.0-parseFloatNazi($i(id + '_discount')[0].value))*0.01;
	$i(id + '_price_label')[0].innerHTML = toMoney(price);
	$i(id + '_price')[0].value = toMoney(price);
    },

    eachLine: function(context, suffix, fn) {
        var id = $(context)[0].id;
	for (var i=0; i < $(context)[0].table_lines; i++) {
            fn($i(id + "_" + i + suffix));
        }
    },

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



    makeAmount: function (value, context) {
	var res = document.createElement("input");
	res.type = "text";
	res.id = bills.getCurrentLineId(context) + '_amount';
	res.name = bills.getCurrentLineName(context) + '[amount]';
	res.setAttribute("autocomplete","off");
	
	res.onkeyup = function (event) {bills.validate();}
	res.value = value;
	return res;
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
    
    makePrice: function (value, order_item_id, context) {	
	var res = document.createElement("span");

	var inp = document.createElement("input");
	inp.type = "hidden";
	inp.id = bills.getCurrentLineId(context) + '_price';
	inp.name = bills.getCurrentLineName(context) + '[price]';
	inp.value = value;
	res.appendChild(inp);
	inp = document.createElement("input");
	inp.type = "hidden";
	inp.id = bills.getCurrentLineId(context) + '_order_item_id';
	inp.name = bills.getCurrentLineName(context) + '[order_item_id]';
	inp.value = order_item_id;
	res.appendChild(inp);
	res.appendChild(bills.makeText('price_label', value, context));
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
	bills.addCell(row, bills.makeText('remaining', line.order_item.amount - line.order_item.billed, context));
	bills.addCell(row, bills.makeAmount(line.order_item.amount, context));
	bills.addCell(row, bills.makeDiscount(0, context));
	bills.addCell(row, bills.makePrice(0, line.order_item.order_item_id, context));
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
	var res = makeTemplateInstance(
            bills.getCurrentLineId('#bill') + "_details",
            bills.getCurrentLineName('#bill') + "[details]",
            "order_template");

	res.updateProducts = function (order_nr) {
            res.discount = LODO.orderList[order_nr].order.price / sum(map(function (x) { return x.price; }, LODO.orderList[order_nr].order.order_items));
            res.table_lines = 0;

            var rows = bills.getRowList(res);
            while (rows.rows.length)
                rows.deleteRow(0);

            $.each(
                LODO.orderList[order_nr].order.order_items,
                function (order_item) {
                    bills.addProduct(
                        {price: LODO.orderList[order_nr].order.price * res.discount,
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

	lines = LODO.billItemList;
	for (var i=0; i<lines.length; i++) {
	    line = lines[i]['bill_item'];
	    bills.addOrder(line);
	}
    }

}
