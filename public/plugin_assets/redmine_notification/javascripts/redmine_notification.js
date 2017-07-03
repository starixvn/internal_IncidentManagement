$(document).ready(function() {
	var notification_menu = $("#top-menu ul li a.redmine-notification"),
		tabDiff = $('a#tab-history-diff'),
	  	tabComparison = $('a#tab-history-comparison');
	
	var total_notifications = parseInt($('#total_notifications input').val(), 10);
	
	if(total_notifications > 0) {
		notification_menu.html(notification_menu.html() + " <span class='total-notifications'>" + total_notifications + "</span>");
	}
	
	$('table.tbl-notifications .mark_viewed').bind('change', function() {
	  	$(this).closest('td').find('a').trigger('click');
	});
	
	$('table.tbl-notifications .mark_all_viewed').bind('change', function() {
		$('table.tbl-notifications .mark_viewed').prop('checked', true);
		
	    $(this).closest('th').find('a').trigger('click');
	});
	
	tabDiff.on('click', function(e) {
	  	tabComparison.removeClass('selected');
	  	tabDiff.addClass('selected');
	  	
	  	$('.history .diff-content').show();
	  	$('.history .diff-comparison-content').hide();
  	});
	  
  	tabComparison.on('click', function(e) {
  		tabDiff.removeClass('selected');
	  	tabComparison.addClass('selected');
	  	
	  	$('.history .diff-content').hide();
	  	$('.history .diff-comparison-content').show();
  	});
});