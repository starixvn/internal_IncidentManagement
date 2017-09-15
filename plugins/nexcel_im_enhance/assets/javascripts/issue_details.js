$(document).ready(function () {
    // alert("details loaded");

    ApplySelect2ToLicensee();
    CopyDateCustomFieldToRedmineCoreField();
    ExpandSummaryDetailAutomatically();

    $("#content .contextual:first a").on("click", function () {
        ApplySelect2ToLicensee();
    });
})

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

function ExpandSummaryDetailAutomatically(){
    $summaryElement = $("#issue_description_and_toolbar").parent();
    $summaryElement.children()[1].click();
}