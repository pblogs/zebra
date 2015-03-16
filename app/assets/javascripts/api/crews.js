jQuery(function () {
  var updateEvent, url_page;
  url_page = jQuery('#url-page').data('url');
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
    drop: function() {
        $(this).remove();
    },
    eventSources:[
      {
        url:url_page
      }
    ],
    timeFormat:'h:mm t{ - h:mm t} ',
    dragOpacity:"0.5",
    eventDrop:function (event, dayDelta, minuteDelta, allDay, revertFunc) {
      return updateEvent(event);
    },
    eventResize:function (event, dayDelta, minuteDelta, revertFunc) {
      return updateEvent(event);
    }
  });
  jQuery("#my-draggable .fc-event").draggable({
    zIndex: 999,
    revert: true,      // will cause the event to go back to its
    revertDuration: 0  //  original position after the drag
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

