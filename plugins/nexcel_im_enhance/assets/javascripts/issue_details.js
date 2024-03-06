$(document).ready(function () {
    // alert("details loaded");

    ApplySelect2ToLicensee();
    CopyDateCustomFieldToRedmineCoreField(35, 36, 34);
    ExpandSummaryDetailAutomatically();

    $("#content .contextual .icon-edit").on("click", function () {
        ApplySelect2ToLicensee();
    });

    $("#watchers .contextual").on("click", function () {
        ConstructSelect2ForWatcher();
    });

    $("#watchers_form a").on("click", function () {
        ConstructSelect2ForWatcher();
    });
    OnChangePriorityLoadBusinessImpactCustomField();
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

            // Hire redmine core search box
            $("#user_search").parent().hide();

            $("#users_for_watcher_select2").remove();

            $("#users_for_watcher").append(html);

            $("#users_for_watcher_select2").select2({
                width: "100%",
                placeholder: "Start typing a name"
            });

            $("#users_for_watcher_select2").on("change", function (e) {
                ids = $("#users_for_watcher_select2").val();
                ReplicateSelectedWatchersOnRedmineCore(ids);
            });
        }
    });
}

function ReplicateSelectedWatchersOnRedmineCore(selectedIds) {
    // Reset all pre-selected input
    $("#users_for_watcher input[type='checkbox']").prop("checked", false);

    selectedIds.forEach(function (element) {
        $("#users_for_watcher input[value='" + element + "']").prop("checked", true);
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
    $("#issue_custom_field_values_21").select2({
        width: '60%',
        tokenizer: function (input, selection, callback) {
            if (input.indexOf(',') < 0) {
                return;
            }
            var unitIds = [];
            $("#issue_custom_field_values_21 option").each(function () {
                unitIds.push($(this).val());
            });

            var values = input.split(",");
            var parts = Object.fromEntries(values.map(s => [s.toLowerCase(), s]));
            var uParts = Object.values(parts);

            uParts.sort(function (a, b) {
                if (a.trim().toLowerCase() > b.trim().toLowerCase()) {
                    return 1;
                }
                return -1;
            });

            for (var i = 0; i < uParts.length; i++) {
                var part = uParts[i];
                part = part.trim();

                var valid = false;
                var value;
                for (var j = 0; j < unitIds.length; j++) {

                    if (part.toLowerCase() === unitIds[j].toLowerCase()) {
                        value = unitIds[j];
                        valid = true;
                        break;
                    }
                }

                var isExisted = false;
                for (let k = 0; k < selection.length; k++) {
                    if (selection[k].id.toLowerCase() === part.toLowerCase()) {
                        isExisted = true;
                        break;
                    }
                }

                if (valid && !isExisted) {
                    callback({ id: value, text: value });
                }
            }
        }
    });
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

function OnChangePriorityLoadBusinessImpactCustomField() {
    $('#issue_priority_id').on('change', function() {
        var priority = $(this).val();
        if (parseInt(priority, 10) === 1 || parseInt(priority, 10) === 2 || parseInt(priority, 10) === 3)
        {
            $("textarea[name='issue[custom_field_values][19]']").val(customFieldBusinessImpactDefaultValue);
        }
        else
        {
            $("textarea[name='issue[custom_field_values][19]']").val('N/A');
        }
    })
}