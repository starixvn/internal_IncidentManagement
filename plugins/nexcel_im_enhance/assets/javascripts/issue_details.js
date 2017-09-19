$(document).ready(function () {
    // alert("details loaded");

    ApplySelect2ToLicensee();
    CopyDateCustomFieldToRedmineCoreField();
    ExpandSummaryDetailAutomatically();

    $("#content .contextual:first a").on("click", function () {
        ApplySelect2ToLicensee();
    });
})

function ApplySelect2ToLicensee() {
    $("#issue_custom_field_values_21").select2();
}

function CopyDateCustomFieldToRedmineCoreField() {
    // TODO: change the number accordingly to the record on database after created the custom field
    $issueStartDate = $("#issue_custom_field_values_39");
    $issueDueDate = $("#issue_custom_field_values_40");

    $($issueStartDate.parent()).detach().appendTo($("#start_date_area").parent());
    $($issueDueDate.parent()).detach().appendTo($("#start_date_area").parent());

    $("#start_date_area").hide();
    $("#due_date_area").hide();

    // $(".cf_39").hide();
    // $(".cf_40").hide();

    // Replace redmine core field with custom field when showing
    $startDateAttr = $(".start-date.attribute");
    $dueDateAttr = $(".due-date.attribute");

    $($startDateAttr).hide();
    $($dueDateAttr).hide();

    $(".cf_39").detach().appendTo($($startDateAttr).parent());
    $(".cf_40").detach().appendTo($($dueDateAttr).parent());

    // In case of new issue
    if ($issueStartDate.val() == "" && $("#issue_start_date").val() != "") {
        var date = $("#issue_start_date").val();
        var now = new Date();

        var day = '' + now.getDate();
        var month = '' + (now.getMonth() + 1);
        var year = now.getFullYear();

        var hours = '' + now.getHours();
        var minutes = '' + now.getMinutes();

        if (month.length < 2) month = '0' + month;
        if (day.length < 2) day = '0' + day;
        if(hours.length < 2) hours = '0' + hours;
        if(minutes.length < 2) minutes = '0' + minutes;

        var inputString = day + "/" + month + "/" + year + " " + hours + ":" + minutes;

        $issueStartDate.val(inputString);
    }

    $issueStartDate.on("change", function () {
        var dateString = $issueStartDate.val().split(' ')[0];
        $("#issue_start_date").val(dateString);
    });

    $issueDueDate.on("change", function () {
        var dateString = $issueDueDate.val().split(' ')[0];
        $("#issue_due_date").val(dateString);
    });
}

function ExpandSummaryDetailAutomatically() {
    $summaryElement = $("#issue_description_and_toolbar").parent();
    $summaryElement.children()[1].click();
}