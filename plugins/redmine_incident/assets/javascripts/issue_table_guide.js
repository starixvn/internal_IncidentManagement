$(document).ready(function() {
	if($('.controller-issues.action-index').length > 0) {
		if($('p.nodata').length > 0) {
			$('#issue_table_guide').insertAfter('p.nodata');
			$('#issue_table_guide').show();
		} else if ($('p.pagination').length > 0) {
			$('#issue_table_guide').insertAfter('p.pagination');
			$('#issue_table_guide').show();
		} else {
			$('#issue_table_guide').hide();
		}
	}
});