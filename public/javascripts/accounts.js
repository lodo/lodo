var accounts = {
  
  // toggle display of the ledger part in accounts/edit
  // @params show = true/false
 toggleLedger: function(show) {
    $('#ledgers').toggle(show);
  },
 
 // add a ledger item to the ledger summary table
 // this is a json callback. only called on success..
 updateLedgerItemsTable: function(data, textStatus) {
    if (textStatus == 'success') {
      var ledger = data.ledger;
      var row = jQuery('<tr class="ledger_item"></tr>');
      row.addCol = function(data) {
	this.append('<td>' + (data ? data : '') + '</td>');
      };
      row.addCol(ledger.number);
      row.addCol(ledger.name);
      row.addCol(ledger.telephone_number);
      row.addCol(ledger.mobile_number);
      row.addCol(ledger.email);
      row.addCol(ledger.credit_days);
      row.addCol(ledger.auto_payment);
      row.addCol(ledger.placement_top);
      row.addCol( ledger.unit_id ? ledger.unit.name : '' );
      row.addCol( ledger.project_id ? ledger.project.name : '');
      row.attr('id', 'ledger_id_' + ledger.id);
      $('#ledger_table').append(row);
      $('#new_ledger')[0].reset();
      accounts.makeRowsClickable();
      stripe();
    }
  },
 
 // callback for failed ajax call to ledger#save
 errorSavingLedger: function(XMLHttpRequest, textStatus, errorThrown) {
    //this; // the options for this ajax request
    alert('Unable to save ledger. ' + errorThrown);
  },

 // call loadLedger when a ledger is clicked
 makeRowsClickable: function() {
    $('.ledger_item').click(accounts.loadLedger);
  },

 // handle click on a ledger line by stuffing it into form
 loadLedger: function() {
    // this: clicked row
    var ledgerId = ( $(this).attr('id').substr(10) );
    $.ajax({
	  type: 'GET',
	  url: '/accounts/' + accounts.getAccountId() + '/ledgers/' + ledgerId,
	  success: accounts.updateLedgerFormHtml,
	  error: accounts.errorLoadingLedger,
	  dataType: 'html'
      });
  },

 updateLedgerFormHtml: function(data, textStatus) {
    $('#ledger_form_wrapper').empty();
    $('#ledger_form_wrapper').append(data);
    //$('#ledger_form_div h3').text('Editing ' + d );
    accounts.scrollToLedger();
  },

 // callback for loadLedger failure
 errorLoadingLedger: function(XMLHttpRequest, textStatus, errorThrown) {
    alert('Unable to load ledger.');
  },

 scrollToLedger: function() {
    $(window).scrollTop( $('#ledger_form_div').offset().top );
  },

 // fetch account id. only works for accounts#edit
 getAccountId: function() {
    return $('form.edit_account').attr('id').substr(13);
  },

 prepareFormForNewLedger: function() {
    accounts.scrollToLedger();
    $.ajax({
	  type: 'GET',
	  url: '/accounts/' + accounts.getAccountId() + '/ledgers/new',
	  success: accounts.updateLedgerFormHtml,
	  error: accounts.errorLoadingLedger,
	  dataType: 'html'
      });
  }

}
