jQuery(document).ready(function() {
  updateTable();
  chosenAutocomplete();
  jQuery('tr.item input').change(function(event) {
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
  var sum = 0;
  jQuery("#table_item tbody tr").each(function(){
   el1 = Number(jQuery(this).find("td.quantity").find('input').val()) * Number(jQuery(this).find("td.price").find('input').val())
   td = jQuery(this).find("td").eq(3)
   td.find('input').val(el1);
   td.find('div.total-price').html(el1);
   sum += Number(td.find('input').val());
  });
  jQuery('.total_amount').html(sum)
  jQuery('#job_estimate_total_amount').val(sum)
};

