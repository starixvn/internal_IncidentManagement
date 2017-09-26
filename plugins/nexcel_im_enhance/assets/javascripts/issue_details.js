$(document).ready(function () {
    // alert("details loaded");

    ApplySelect2ToLicensee();
    CopyDateCustomFieldToRedmineCoreField(34, 35, 36);
    ExpandSummaryDetailAutomatically();

    $("#content .contextual .icon-edit").on("click", function () {
        ApplySelect2ToLicensee();
    });

    $("#watchers .contextual").on("click", function () {
        ConstructSelect2ForWatcher();
    });
})

function ConstructSelect2ForWatcher() {

    $("#ajax-modal").on("dialogopen", function () {
        if ($("#ajax-modal").html().indexOf("users_for_watcher_select2") <= -1) {
            // element not existed
            var html = "";
            // Use old watcher
            html = GetHtmlOptionString();

            // Append crated html to dom
            $("#users_for_watcher > label").hide();

            $("#new-watcher-form > p:nth-child(5)").hide();

            $("#users_for_watcher_select2").remove();

            $("#users_for_watcher").append(html);

            $("#users_for_watcher_select2").select2({
                width: "100%"
            });

            $("#users_for_watcher_select2").on("change", function(e){
                ids = $("#users_for_watcher_select2").val();
                ReplicateSelectedWatchersOnRedmineCore(ids);
            });
        }
    });
}

function ReplicateSelectedWatchersOnRedmineCore(selectedIds){
    // Reset all pre-selected input
    $("#users_for_watcher input[type='checkbox']").prop("checked", false);

    selectedIds.forEach(function(element) {
        $("#users_for_watcher input[value='" + element +"']").prop("checked", true);
    }, this);
}

function GetHtmlOptionString() {
    // Get data
    var datas = $("#users_for_watcher > label");
    var htmlToReplace = "<select id='users_for_watcher_select2' multiple='multiple'>";
    datas.each(function (i, data) {
        htmlToReplace += "<option value='" + data.firstChild.value + "'>" + data.innerText + "</option>";
    });
    htmlToReplace += "</select>";

    return htmlToReplace;
}

function ApplySelect2ToLicensee() {
    $("#issue_custom_field_values_21").select2();
}

function CopyDateCustomFieldToRedmineCoreField(startDateCfId, dueDateCfId, customerFeedbackCfId) {
    // TODO: change the number accordingly to the record on database after created the custom field

    var startDateCfIdString = "issue_custom_field_values_" + startDateCfId;
    var dueDateCfIdString = "issue_custom_field_values_" + dueDateCfId;
    var customerFeedbackCfIdString = "issue_custom_field_values_" + customerFeedbackCfId;

    $issueStartDate = $("#" + startDateCfIdString);
    $issueDueDate = $("#" + dueDateCfIdString);
    $customerFeedbackDate = $("#" + customerFeedbackCfIdString);

    // Set size for 3 custom_field
    $($issueStartDate).attr("size", 30);
    $($issueDueDate).attr("size", 30);
    $($customerFeedbackDate).attr("size", 30);

    $($customerFeedbackDate.parent()).detach().appendTo($("#attributes > div:nth-child(1) > div.splitcontentright"));
    $($issueStartDate.parent()).detach().appendTo($("#attributes > div:nth-child(1) > div.splitcontentright"));
    $($issueDueDate.parent()).detach().appendTo($("#attributes > div:nth-child(1) > div.splitcontentright"));

    $("#start_date_area").hide();
    $("#due_date_area").hide();

    // Replace redmine core field with custom field when showing
    $startDateAttr = $(".start-date.attribute");
    $dueDateAttr = $(".due-date.attribute");

    $($startDateAttr).hide();
    $($dueDateAttr).hide();

    $(".cf_" + customerFeedbackCfId).detach().appendTo($("#content .attributes:first .splitcontent:first .splitcontentleft:last"));
    $(".cf_" + startDateCfId).detach().appendTo($("#content .attributes:first .splitcontent:first .splitcontentleft:last"));
    $(".cf_" + dueDateCfId).detach().appendTo($("#content .attributes:first .splitcontent:first .splitcontentleft:last"));

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
        if (hours.length < 2) hours = '0' + hours;
        if (minutes.length < 2) minutes = '0' + minutes;

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