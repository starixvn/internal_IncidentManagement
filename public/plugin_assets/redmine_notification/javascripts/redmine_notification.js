$(document).ready(function() {
	var notification_menu = $("#top-menu ul li a.redmine-notification");
	
	var total_notifications = parseInt($('#total_notifications input').val(), 10);
	
	if(total_notifications > 0) {
		notification_menu.html(notification_menu.html() + " <span class='total-notifications'>" + total_notifications + "</span>");
	}
});