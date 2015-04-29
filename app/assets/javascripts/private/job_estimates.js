jQuery(document).ready(function() {
  updateTable();
  chosenAutocomplete();
  jQuery('tr.item input, .total_amount_table input').change(function(event) {
    updateTable();
  });
});


jQuery(function () {
  jQuery('#job_estimate_name_client').autocomplete({
    source: jQuery('#job_estimate_name_client').data("autocomplete"),
    minLength: 3
  });

  jQuery(".job_estimate").nestedFields({
    itemSelector: ".item",
    containerSelector: "tbody",
    afterInsert: function(item) {
      jQuery('tr.item input').change(function(event) {
        updateTable();
      });
      chosenAutocomplete();
    },

    afterRemove: function(item) {
      jQuery("tr:hidden").remove();
      updateTable();
    }
  });
});

function chosenAutocomplete() {
  jQuery('.autocomplete').autocomplete({
    source: jQuery('.autocomplete').data("autocomplete"),
    minLength: 3
  });
}

function updateTable() {
  var sub_total = 0;
  var discount_sum = 0;
  var shipping_sum = 0;
  var total_sum = 0;
  jQuery("#table_item tbody tr").each(function(){
   el1 = Number(jQuery(this).find("td.quantity").find('input').val()) * Number(jQuery(this).find("td.price").find('input').val())
   td = jQuery(this).find("td").eq(3)
   td.find('input').val(el1);
   td.find('div.total-price').html(el1);
    sub_total += Number(td.find('input').val());
  });

  discount_sum += sub_total * Number(jQuery('table tr').find("td.discount").find('input').val()) / 100
  shipping_sum += Number(jQuery('table tr').find('input#job_estimate_shipping_charges').val())
  total_sum += sub_total + shipping_sum - discount_sum

  jQuery('.sub_total').html(sub_total)
  jQuery('#job_estimate_sub_total_amount').val(sub_total)
  jQuery('.discount_sum').html(discount_sum)
  jQuery('.shipping_sum').html(shipping_sum)
  jQuery('.total_sum').html(total_sum)
  jQuery('#job_estimate_total_amount').val(total_sum)
};

