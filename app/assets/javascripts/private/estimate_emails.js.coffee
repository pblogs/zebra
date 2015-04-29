jQuery ->
  jQuery('input#job_estimate_name_client').bind 'change keyup', ->
    client_name = jQuery(this).val()

    jQuery.ajax
      url: '/admin/job_estimates/collect_emails',
      dataType: 'json'
      data: {client_name}
      success: (data, textStatus, jqHXR) ->
        console.log data.emails
        jQuery("#job_estimate_emails").val(data.emails)
