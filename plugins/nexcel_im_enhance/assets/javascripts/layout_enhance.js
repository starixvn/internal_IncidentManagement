$(document).ready(function () {
    // Remove file tab in people plugins
    $("#tab-files").hide();

    // Re-arrange in home page
    $(".news.box").detach().appendTo('.splitcontentleft');

    // Add Select2 to project search
    $("#quick-search select").select2();


    $(".dmsf-approvalworkflows").addClass("icon");

    // Remove tab-button
    $(".tabs-buttons").remove();

    // Insert Notice in Help and Support
    if($("#sidebar").find('div.wiki').length != 0){
        $("#sidebar").prepend("<h3>Notice</h3>");
    }

    // On mouse leave for drop-it
    $(".dropit-submenu").on("mouseleave", function(){
        HideCustomQueriesDropitMenu();
    });

    $(".dropit-trigger").on("mouseleave", function(){
        HideCustomQueriesDropitMenu();
    })

    //Placeholder text for new incidents
    if($('.controller-issues').length > 0 && $('form#issue-form').length > 0) {
		$('form#issue-form input#issue_subject').attr('placeholder', 'Naming conventions of incident title, please follow this format: Site/System | Incident Title or LicenseeName | Incident title');
    };

    InitChangePriorityEvent();
});

function HideCustomQueriesDropitMenu(){
    $('.dropit-open').removeClass('dropit-open').find('.dropit-submenu').hide();
}

function InitChangePriorityEvent() {
        $('#issue_priority_id').on('change', function() {
            var priority = $(this).val();
            if (parseInt(priority, 10) === 1 || parseInt(priority, 10) === 2 || parseInt(priority, 10) === 3)
            {
                FillValueToRequiredField('', true);
            }
            else {
                FillValueToRequiredField('N/A');
            }
        })
}

function FillValueToRequiredField(value, isShowRequired = false) {
    var requiredCustomFields = ['issue_custom_field_values_56', 'issue_custom_field_values_57', 'issue_custom_field_values_58'];
    requiredCustomFields.forEach(function(item) {
        $("#" + item).val(value);
        var labelChilds = $('label[for="' + item +'"]').children();
        if (isShowRequired) {
            if (labelChilds.length < 2) $('label[for="' + item +'"]').append("<span class='required'>*</span>");
        } else {
            if (labelChilds.length === 2) labelChilds.eq(1).remove();;
        }
    });

}
