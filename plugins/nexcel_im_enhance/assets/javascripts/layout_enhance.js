$(document).ready(function () {
    // Re-arrange in home page
    $(".news.box").detach().appendTo('.splitcontentleft');

    // Add Select2 to project search
    $("#quick-search select").select2();

    // // Remove DMSF upload button
    // $(".dmsf_uploader").remove();

    $(".dmsf-approvalworkflows").addClass("icon");

    ApplySelect2ToLicensee();

    $("#content .contextual:first a").on("click", function () {
        ApplySelect2ToLicensee();
    });

    // Remove tab-button
    $(".tabs-buttons").remove();

    // Insert Notice in Help and Support
    if($("#sidebar").find('div.wiki').length != 0){
        $("#sidebar").prepend("<h3>Notice</h3>");
    }

    // On mouse leave for drop-it
    $(".dropit-submenu").on("mouseleave", function(){
        $('.dropit-open').removeClass('dropit-open').find('.dropit-submenu').hide();
    });

    //Placeholder text for new incidents
    if($('.controller-issues').length > 0 && $('form#issue-form').length > 0) {
		$('form#issue-form input#issue_subject').attr('placeholder', 'Naming conventions of incident title, please follow this format: Site/System | Incident Title or LicenseeName | Incident title');
    };
    
    CopyDateCustomFieldToRedmineCoreField();

    $("#content .contextual a:first").on("click", function(){
        $summaryElement = $("#issue_description_and_toolbar").parent();
        $summaryElement.children()[1].click();
    });
});

function ApplySelect2ToLicensee(){
    $("#issue_custom_field_values_21").select2();
}

function CopyDateCustomFieldToRedmineCoreField(){
    // TODO: change the number accordingly to the record on database after created the custom field
    $issueStartDate = $("#issue_custom_field_values_39");
    $issueDueDate = $("#issue_custom_field_values_40");

    $($issueStartDate.parent()).detach().appendTo($("#start_date_area").parent());
    $($issueDueDate.parent()).detach().appendTo($("#start_date_area").parent());

    $("#start_date_area").hide();
    $("#due_date_area").hide();

    $(".cf_39").hide();
    $(".cf_40").hide();

    $issueStartDate.on("change", function(){
        var dateString = $issueStartDate.val().split(' ')[0];
        $("#issue_start_date").val(dateString);
    });

    $issueDueDate.on("change", function(){
        var dateString = $issueDueDate.val().split(' ')[0];
        $("#issue_due_date").val(dateString);
    });
}