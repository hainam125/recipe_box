// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var draw_star = function(form_id, value){
  for(var i = 0; i < 6; i++){
	if(i <= value){
	  $("#" + form_id + "_star_" + i).addClass("on");
	}
	else {
	  $("#" + form_id + "_star_" + i).removeClass("on");
	} 
  }
}
var ready = function(){
  $(".rating_star").on("click", function(){
	$this = $(this);
	var value = $this.attr("data-value");
	var form_id = $this.attr("data-form-id");
	$this.closest('form').find('#value').val(value);
	draw_star(form_id, value);
  });
  $("form").on("click", ".remove_field", function(event){
	$(this).prev("input[type=hidden]").val(1);
	$(this).closest(".nested_form").hide();
	event.preventDefault();
  });
  $("form").on("click", ".add_field", function(event){
	var id = new Date().getTime();
	regex = new RegExp($(this).data('id'),'g');
	$(this).before($(this).data("fields").replace(regex,id));
	event.preventDefault();
  });
}
$(document).on("turbolinks:load", function(){
  ready();
});