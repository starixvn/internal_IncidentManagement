var CORE = (function ($) {
	return {
		initialize: function () {
			if ($('#issue_priority_id').val() == 1) {
				$('.lbl-letstalk-checkbox').show();
				$('#chkLetstalk_yesno_attribute').attr('checked', false);
			} else {
				$('.lbl-letstalk-checkbox').hide();
			}

			$('#chkLetstalk_yesno_attribute').on('change', function () {
				CORE.chkLetstalkChecking(this);
			});

			$('#issue_priority_id').on('change', function () {
				CORE.lblLetstalkChecking(this);
			});

			$("input[name = 'commit']").on('click', function () {
				return CORE.ConfirmSubmit();
			});

			$("input[name = 'continue']").on('click', function () {
				return CORE.ConfirmSubmit();
			});
		},

		ConfirmSubmit: function () {
			if ($('#chkLetstalk_yesno_attribute').is(':checked')) {
				var isConfirm = confirm('Are you sure you want to push the issue to Letstalk ?');
				if (!isConfirm) {
					return false;
				}
			}
		},

		chkLetstalkChecking: function (obj) {
			if (obj.checked) {
				$('.lbl-letstalk-comment').show();
			} else {
				$('.lbl-letstalk-comment').hide();
			}
		},

		lblLetstalkChecking: function (obj) {
			if ($(obj).val() == 1) {
				$('.lbl-letstalk-checkbox').show();
			} else {
				$('.lbl-letstalk-checkbox').hide();
				$('#chkLetstalk_yesno_attribute').attr('checked', false);
				$('.lbl-letstalk-comment').hide();
			}
		}
	};
}(jQuery));

$(document).ready(function () {
	CORE.initialize();
});