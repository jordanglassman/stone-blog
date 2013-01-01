# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$('#post_state').change ->
		$.ajax
			url : '/posts'
			data :
				state : $("#post_state option:selected").val()
				page : 1
				
	window.setTimeout "$('#notice').fadeOut('slow')", 5000
				

