jQuery(function () {
  var updateEvent, url_page;
  url_page = jQuery('#calendar').data('url');

  jQuery('#my-draggable .fc-event').each(function() {

    // create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
    // it doesn't need to have a start or end
    var eventObject = {
      id: jQuery(this).data('id'),
      url: jQuery(this).data('url'),
      title: jQuery.trim(jQuery(this).text()) // use the element's text as the event title
    };

    // store the Event Object in the DOM element so we can get to it later
    jQuery(this).data('eventObject', eventObject);

    // make the event draggable using jQuery UI
    jQuery(this).draggable({
      zIndex: 999,
      revert: true,      // will cause the event to go back to its
      revertDuration: 0  //  original position after the drag
    });

  });

  jQuery("#calendar").fullCalendar({
    header:{
      left:'prev,next today',
      center:'title',
      right:'month,agendaWeek,agendaDay'
    },
    defaultView:'month',
    height:800,
    editable:true,
    droppable:true,
    drop: function(date, allDay) {
      // this function is called when something is dropped
      // retrieve the dropped element's stored Event Object
      var originalEventObject = jQuery(this).data('eventObject');

      // we need to copy it, so that multiple events don't have a reference to the same object
      var copiedEventObject = jQuery.extend({}, originalEventObject);

      // assign it the date that was reported
      copiedEventObject.start = date;
      copiedEventObject.end = date;
      copiedEventObject.allDay = allDay;
      updateEvent(copiedEventObject);
      // render the event on the calendar
      // the last `true` argument determines if the event "sticks" (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)
      jQuery('#calendar').fullCalendar('renderEvent', copiedEventObject, true);
      jQuery(this).remove();
    },
    eventSources:[{url:url_page}],
    timeFormat:'h:mm t{ - h:mm t} ',
    dragOpacity:"0.5",
    eventDrop:function (event, dayDelta, minuteDelta, allDay, revertFunc) {
      return updateEvent(event);
    },
    eventResize:function (event, dayDelta, minuteDelta, revertFunc) {
      return updateEvent(event);
    },
    eventDragStop:function (event, dayDelta, minuteDelta, revertFunc) {
      return updateEvent(event);
    }
  });

  return updateEvent = function (event) {
    return jQuery.ajax({
      url:"/api/crews/schedule_job",
      data:{
        id:event.id,
        job:{
          started_on: event.start.format(),
          completed_on: event.end.format()
        }
      },
      type:'PUT',
      dataType:'json'
    });
  };
});

