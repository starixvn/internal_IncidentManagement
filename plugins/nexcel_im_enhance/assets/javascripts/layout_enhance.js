const requiredCustomFields = ['issue_custom_field_values_56', 'issue_custom_field_values_57', 'issue_custom_field_values_58'];

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
    var isNew = window.location.href.includes('issues/new');

    if (isNew) {
        InitChangePriorityEventNewIssue();
    } else {
        InitChangePriorityEventEditIssue();
    }
});

function HideCustomQueriesDropitMenu(){
    $('.dropit-open').removeClass('dropit-open').find('.dropit-submenu').hide();
}

function InitChangePriorityEventEditIssue() {
    var currentPriority = $('#issue_priority_id').val();
    $('#issue_priority_id').data('val', currentPriority);

    $('#issue_priority_id').on('change', function() {
        var initPriority = parseInt($(this).data('val'), 10);
        var priority = parseInt($(this).val(), 10);

        if (!isCriticalPriority(initPriority) && isCriticalPriority(priority))
        {
            requiredCustomFields.forEach(function(item) {
                var currentValue = $("#" + item).val();
                if (currentValue === 'N/A') {
                    $("#" + item).val('');
                }
            });
        }
    })
}

function isCriticalPriority(id) {
    return id === 1 || id === 2 || id === 3;
}

function InitChangePriorityEventNewIssue() {
        $('#issue_priority_id').on('change', function() {
            var priority = parseInt($(this).val(), 10);
            if (isCriticalPriority(priority))
            {
                FillValueToRequiredField('');
                ShowHideRequiredCustomFields(true);
            }
            else {
                FillValueToRequiredField('N/A');
                ShowHideRequiredCustomFields(true);
            }
        })
}

function FillValueToRequiredField(value) {
    requiredCustomFields.forEach(function(item) {
        $("#" + item).val(value);
    });
}

function ShowHideRequiredCustomFields(isRequired = false) {
    requiredCustomFields.forEach(function(item) {
        var labelChilds = $('label[for="' + item +'"]').children();
        if (isRequired) {
            if (labelChilds.length < 2) $('label[for="' + item +'"]').append("<span class='required'>*</span>");
        } else {
            if (labelChilds.length === 2) labelChilds.eq(1).remove();;
        }
    });
}
