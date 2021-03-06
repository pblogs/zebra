// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui/draggable
//= require jquery-ui/droppable
//= require jquery-ui/resizable
//= require jquery-ui/autocomplete
//= require jquery.minicolors
//= require jquery_ujs
//= require fullcalendar
//= require jquery.nested-fields
//= require bootstrap/modal
//= require_self
//= require_tree ./base
//= require_tree ./elements
//= require_tree ./pages
//= require_tree ./private
//= require_tree ./api

jQuery.noConflict()

jQuery(document).ready(function($) {
  $('.colorpicker').minicolors()
});
