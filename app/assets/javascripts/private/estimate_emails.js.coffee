jQuery ->
  jQuery('input#customer_name').bind 'focusout', ->
    client_name = jQuery(this).val()

    jQuery.ajax
      url: '/admin/job_estimates/collect_emails',
      dataType: 'json'
      data: {client_name}
      success: (data, textStatus, jqHXR) ->
        # console.log data.emails
        jQuery("#emails_field").val(data.emails)
