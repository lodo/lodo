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
      row.addCol(ledger.unit_id);
      row.addCol(ledger.project_id);
      row.attr('id', 'ledger_id_' + ledger.id);
      $('#ledger_table').append(row);
      $('#new_ledger')[0].reset();
    }
  },
 
 // callback for failed ajax call to ledger#save
 errorSavingLedger: function(XMLHttpRequest, textStatus, errorThrown) {
    //this; // the options for this ajax request
    alert('Unable to save ledger. ' + errorThrown);
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
    $('#ledger_form')[0].reset();
    // update url & crap for form..
    $('#ledger_form').attr('action', '/accounts/' + accounts.getAccountId() + '/ledgers');
    $('#ledger_form_method').attr('value', 'post');
    $('#ledger_form_div h3').text('New ledger');
  },

 // callback for loadLedger success
 stuffFormWithLedger: function(data, textStatus) {
    $('#ledger_form')[0].reset();
    var ledger = data.ledger;
    accounts.scrollToLedger();
    $('#ledger_number').val(ledger.number);
    $('#ledger_name').val(ledger.name);
    $('#ledger_telephone_number').val(ledger.telephone_number);
    $('#ledger_mobile_number').val(ledger.mobile_number);
    $('#ledger_email').val(ledger.email);
    $('#ledger_bank_account').val(ledger.bank_account);
    $('#ledger_foreign_bank_number').val(ledger.foreign_bank_number);
    $('#ledger_credit_days').val(ledger.credit_days);
    $('#ledger_auto_payment').attr('checked', (ledger.auto_payment ? 'checked' : '') );
    $('#ledger_placement_top').attr('checked', (ledger.placement_top ? 'checked' : '') );
    $('#ledger_net_bank').attr('checked', (ledger.net_bank ? 'checked' : '') );
    $('#ledger_unit_id').val(ledger.unit_id);
    $('#ledger_project_id').val(ledger.project_id);
    $('#ledger_debit_text').val(ledger.debit_text);
    $('#ledger_credit_text').val(ledger.credit_text);
    $('#ledger_comment').val(ledger.comment);
    // update url & crap for form..
    $('#ledger_form').attr('action', '/accounts/' + ledger.account.id + '/ledgers/' + ledger.id);
    //$('#ledger_form').attr('method', 'post');
    $('#ledger_form_method').attr('value', 'put');
    $('#ledger_form_div h3').text('Editing ' + ledger.name);
  }

}
