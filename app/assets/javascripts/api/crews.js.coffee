# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  url_page = jQuery('#url-page').data('url')

  jQuery("#calendar").fullCalendar(
    editable: true,
    header:
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    defaultView: 'month',

    height: 800,
    slotMinutes: 30,

    #alert(url_page)
    eventSources: [{
      url: url_page,
    }],

    timeFormat: 'h:mm t{ - h:mm t} ',
    dragOpacity: "0.5"

    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      updateEvent(event);

    eventResize: (event, dayDelta, minuteDelta, revertFunc) ->
      updateEvent(event);

  );

  #TODO fix update event method
  updateEvent = (the_event) ->
    $.update "/admin/crews/" + the_event.id + "/schedule_job",
      crew:
        name: the_event.name,
        starts_at: "" + the_event.start,
        ends_at: "" + the_event.end
