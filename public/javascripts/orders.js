
var orders = {

    getProductPrice: function(id) 
    {
	
	for (var i=0; i<LODO.productList.length; i++) {
	    if (LODO.productList[i].product.id == id) 
		{
		    return LODO.productList[i].product.price;
		}
		
	}
	return 0.0;
    },

    validate: function()
    {
	for (var i=0; i < LODO.productLines; i++) {
	    var price = $('#unitPrice_' + i)[0];
	    var productId = $('#product_id_' + i)[0].value;
		
	    price.innerHTML = toMoney(orders.getProductPrice(productId));
	}
	orders.sumColumn();
    },

    sumColumn: function()
    {
	var sum = 0.0;
	for (var i=0; i < LODO.productLines; i++) {
	    sum += parseFloatNazi($('#amount_' + i)[0].value) * parseFloatNazi($('#unitPrice_'+i)[0].innerHTML);
	    
	    orders.setPrice(i,parseFloatNazi($('#unitPrice_'+i)[0].innerHTML)*parseFloatNazi($('#amount_' + i)[0].value) * (100.0-parseFloatNazi($('#discount_'+i)[0].value))*0.01);

	}
	
	$('#dynfield_sum')[0].innerHTML = toMoney(sum);
    },

    makeProductSelect: function(value) {
	var sel = document.createElement("select");
	sel.name = "products[" + LODO.productLines+"][product_id]";
	sel.id = "product_id_"+ LODO.productLines;
    
	for (var i=0; i<LODO.productList.length; i++) {
	    sel.add(new Option("" + LODO.productList[i].product.name, LODO.productList[i].product.id), null);
	}

	sel.onchange = function (event) {orders.validate();}
	sel.value = value;

	return sel;
    },

    makeAmount: function(value) {
	var res = document.createElement("input");
	res.type="text";
	res.name = "products[" + LODO.productLines+"][amount]";
	res.id='amount_' + LODO.productLines;
	res.setAttribute("autocomplete","off");
	
	res.onkeyup = function (event) {orders.validate();}
	res.value = value;

	return res;
    },

    makeDiscount: function (value) {
	var res = document.createElement("input");
	res.type="text";
	res.id='discount_' + LODO.productLines;
	res.setAttribute("autocomplete","off");
	
	res.onkeyup = function (event) {orders.validate();}
	res.value = value;
	return res;
    },
    
    makePrice: function (value) {
	
	var res = document.createElement("span");

	var inp = document.createElement("input");
	inp.type="hidden";
	inp.id='price_' + LODO.productLines;
	inp.name = "products[" + LODO.productLines+"][price]";
	inp.value = value;
	res.appendChild(inp);
	res.appendChild(orders.makeText('priceLabel'));
	return res;
    },

    setPrice: function(line, value) {
	$('#price_'+line)[0].value = toMoney(value);
	$('#priceLabel_'+line)[0].innerHTML = toMoney(value);
    },

    makeText: function(id) {
	var res = document.createElement("span");
	res.id=id + "_" + LODO.productLines;
	return res;
    },

    addProduct: function(line)
    {
	if(!LODO.productLines) {
	    LODO.productLines = 0;
	}

	var opTable = $('#products')[0];
	
	var row = opTable.insertRow(opTable.rows.length);
    
	row.addCell = function (content) {
	    var c = row.insertCell(this.cells.length);
	    c.appendChild(content);
	}
    
	row.addCell(orders.makeProductSelect(line?line.product_id:null));
	row.addCell(orders.makeText('unitPrice'));
	row.addCell(orders.makeAmount(line?line.amount:0));
	row.addCell(orders.makeDiscount(0));
	row.addCell(orders.makePrice());
	
	var cell = document.createElement("span");
	/*
	  If we are reediting an old line, insert the id so we can match them together
	 */
	if (line) {
	    var line_id = document.createElement("input");
	    line_id.type = "hidden";
	    line_id.name = "products[" + LODO.productLines+"][id]";
	    line_id.value = line.id;
	    cell.appendChild(line_id);
	}

	row.addCell(cell);
    
	LODO.productLines++;
	stripe('#operations_table');
	orders.validate();
    },

    addPredefined: function(){
	lines = LODO.orderItemList;
	for (var i=0; i<lines.length; i++) {
	    line = lines[i]['order_item'];
	    orders.addProduct(line);
	}
    }

}
