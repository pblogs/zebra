jQuery( document ).ready(function() {
jQuery(function () {
  var multi = jQuery('.one-crew');
  var links_array = [];

  jQuery.each(multi, function (index, item) {
    links_array.push(jQuery(item).data('ids'));
  });

  jQuery('.list-crews .one-crew').click(function(el){
    var  my_object = jQuery(this)
    var crew_color = my_object.find('.crew-color').data('color');
    var url = my_object.data('ids');

    if(my_object.hasClass("selected")) {
      my_object.removeClass('selected');
      my_object.find('.crew-color').css("background-color", "#fff");
      jQuery('#select-crews-calendar').fullCalendar('removeEventSource', [url]);
    }
    else {
      my_object.addClass("selected");
      my_object.attr("data-ids", url);
      my_object.find('.crew-color').css("background-color", crew_color);
      jQuery('#select-crews-calendar').fullCalendar('addEventSource', url);
    }
  });

  var updateEvent, url_page, crew_id;
      url_page = jQuery('#calendar').data('url');
      crew_id = jQuery('#calendar').data('crew');

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
    forceEventDuration:true,
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
      //jQuery('#calendar').fullCalendar('renderEvent', originalEventObject, true);
    },
    eventSources:[url_page],
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
    },
    eventOverlap: function(stillEvent, movingEvent) {
        return stillEvent.allDay && movingEvent.allDay;
    },
    eventRender: function(event, element) {
      var el = element.children('.fc-event-inner');
      el.append( "<div class='pull-right' id='deleteEv'>&nbsp;Delete&nbsp;</span>" );
      el.append( "<div class='pull-right'><a href='/admin/jobs/"+event.job_id+"/edit'>&nbsp;Edit</a> | </div>" );
      el.append( "<div class='pull-right'><a href='/admin/jobs/"+event.job_id+"'>Open</a> | </div>" );
      el.find("#deleteEv").click(function() {
        jQuery('#calendar').fullCalendar('removeEvents',event._id);
        jQuery.ajax({
          url: '/api/events/'+event._id,
          type: 'DELETE'
        })
      });
    }
  });


  jQuery("#select-crews-calendar").fullCalendar({
    header:{
      left:'prev,next today',
      center:'title',
      right:'month,agendaWeek,agendaDay'
    },
    defaultView:'month',
    height:800,
    eventSources: links_array,
    timeFormat:'h:mm t{ - h:mm t} '
  });

  return updateEvent = function (event) {
    console.log("EVENT ID  " + event._id);
    return jQuery.ajax({
      url:"/api/crews/schedule_job",
      data:{
        id:event.id,
        event:{
          started_on: event.start.format(),
          completed_on: event.end.format(),
          crew_id: crew_id
        }
      },
      success: function(text) {
        jQuery('#calendar').fullCalendar('refetchEvents');
      },
      type:'PUT',
      dataType:'json'
    });
  };
});
});
