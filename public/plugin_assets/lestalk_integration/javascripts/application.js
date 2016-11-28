var CORE = (function ($) {
	return {
		initialize: function () 
		{
 			

			$('#chkLetstalk_yesno_attribute').on('change',function(){
				if (this.checked) {
					$('.lbl-letstalk-comment').removeClass('hidden');
				}	
				else
				{
					$('.lbl-letstalk-comment').addClass('hidden');
				}
			});

			$("input[name = 'commit']").on('click', function(){
                               return CORE.ConfirmSubmit();			
                        });

			$("input[name = 'continue']").on('click', function(){
                               return CORE.ConfirmSubmit();			
                        });			
		},
		
		ConfirmSubmit : function(){
				if($('#chkLetstalk_yesno_attribute').is(':checked'))
				{
					var isConfirm = confirm('Are you sure you want to push the issue to Letstalk ?');
					if(!isConfirm)
					{
						return false;
					}					
					
				}
		}
	};
}(jQuery));

$(document).ready(function () {    

    CORE.initialize();
});