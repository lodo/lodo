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
      row.insertAfter('.ledger_item:last');
      $('#new_ledger')[0].reset();
    }
  },
 
 // callback for failed ajax call to ledger#save
 errorSavingLedger: function(XMLHttpRequest, textStatus, errorThrown) {
    //this; // the options for this ajax request
    alert('Unable to save ledger.');
  },

 // handle click on a ledger line by stuffing it into form
 loadLedger: function() {
    // this: clicked row
    var ledgerId = ( $(this).attr('id').substr(10) );
    $.ajax({
	  type: 'GET',
	  url: '/accounts/0/ledgers/' + ledgerId,
	  success: accounts.stuffFormWithLedger,
	  error: accounts.errorLoadingLedger,
	  dataType: 'json'
      });
  },

 // callback for loadLedger failure
 errorLoadingLedger: function(XMLHttpRequest, textStatus, errorThrown) {
    alert('Unable to load ledger.');
  },

 // callback for loadLedger success
 stuffFormWithLedger: function(data, textStatus) {
    $('#new_ledger')[0].reset();
    var ledger = data.ledger;
    console.log(ledger);
    $(window).scrollTop( $('#ledger_form_div').offset().top );
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
    $('#new_ledger').attr('action', '/accounts/' + ledger.account.id + '/ledgers/' + ledger.id);
    $('#new_ledger').attr('method', 'put');
  }
 
}
