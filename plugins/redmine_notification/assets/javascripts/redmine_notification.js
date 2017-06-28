$(document).ready(function() {
	var notification_menu = $("#top-menu ul li a.redmine-notification");
	
	var total_notifications = parseInt($('#total_notifications input').val(), 10);
	
	if(total_notifications > 0) {
		notification_menu.html(notification_menu.html() + " <span class='total-notifications'>" + total_notifications + "</span>");
	}
	
	$('#main').bind('change', 'table.tbl-notifications .mark_viewed', function() {
	  	$.ajax({
      		type: $(this).data('method'),
      		url: $(this).data('url'),
      		data: { id: $(this).data('id') }
   		}).done(function() {
    		alert( "success" );
	  	}).fail(function() {
    		alert( "error" );
  		});    
	});
	
	$('table.tbl-notifications .mark_all_viewed').bind('change', function() {
  		$.ajax({
      		type: $(this).data('method'),
      		url: $(this).data('url')
   		}).done(function() {
    		alert( "success" );
	  	}).fail(function() {
    		alert( "error" );
  		});     
	});
});