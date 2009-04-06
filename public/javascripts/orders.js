/**
   Separate hournals namespace for orderss specific scripting
 */

var orders = {

    /**
       Look up price for specified product
     */
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

    /**
       Validate stuff. Currently can't find any errors. :-(

       FIXME: Detect broken numbers
     */
    validate: function()
    {
	for (var i=0; i < LODO.productLines; i++) {
	    var price = $('#unitPrice_' + i)[0];
	    var productId = $('#product_id_' + i)[0].value;
		
	    price.innerHTML = toMoney(orders.getProductPrice(productId));
	}
	orders.sumColumn();
    },

    /**
       Sum all the prices up.
     */
    sumColumn: function()
    {
	var sum = 0.0;
	for (var i=0; i < LODO.productLines; i++) {
	    var val = parseFloatNazi($('#unitPrice_'+i)[0].innerHTML)*parseFloatNazi($('#amount_' + i)[0].value) * (100.0-parseFloatNazi($('#discount_'+i)[0].value))*0.01;
	    sum += val;
	    orders.setPrice(i,val);
	}
	
	orders.setTotalPrice(sum);
    },

    /**
       Make a select DOM node for product selection.
     */
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

    /**
       Returns a DOM node suitable for using as a amount input box.
     */
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

    /**
       Returns a DOM node suitable for using as a discount input box.
     */
    makeDiscount: function (value) {
	var res = document.createElement("input");
	res.type="text";
	res.id='discount_' + LODO.productLines;
	res.setAttribute("autocomplete","off");
	
	res.onkeyup = function (event) {orders.validate();}
	res.value = value;
	return res;
    },
    
    /**
       Returns a DOM node suitable for using as a price hidden input.
     */
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

    /**
       Set the total price, taking into account the discount_total, and converting the number to a string with suitable formating.
     */
    setTotalPrice: function(price) {
	price = price*(100.0-parseFloatNazi($('#discount_total')[0].value))*0.01;
	$('#dynfield_sum')[0].innerHTML = toMoney(price);
	$('#price')[0].value = toMoney(price);
    },

    /**
       Sets the price of a specific line, not taking discount into account.
     */
    setPrice: function(line, value) {
	$('#price_'+line)[0].value = toMoney(value);
	$('#priceLabel_'+line)[0].innerHTML = toMoney(value);
    },

    /**
       Make a generic span DOM node, suitable for a read only message.
     */
    makeText: function(id) {
	var res = document.createElement("span");
	res.id=id + "_" + LODO.productLines;
	return res;
    },

    /**
       Add a new product to the product list
     */
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
	row.addCell(orders.makeDiscount(toMoney(line?(100.0 - 100*line.price/(orders.getProductPrice(line.product_id)*line.amount)):0.0)));
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
	stripe();
	orders.validate();
    },

    /**
       Add all predefined product lines from the LODO.orderItemList array.
    */

    addPredefined: function(){
	lines = LODO.orderItemList;
	for (var i=0; i<lines.length; i++) {
	    line = lines[i]['order_item'];
	    orders.addProduct(line);
	}
    }

}
