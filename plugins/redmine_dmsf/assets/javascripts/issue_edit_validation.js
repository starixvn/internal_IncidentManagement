var issueEditValidation = (function ($) {
    function initSubmitEditIssueEvent(customFieldId, keyword) {
        $('#issue-form').submit(function (e) {
            hideError();
            e.preventDefault();
            var typeFieldValues = $(customFieldId).val();
            var issueStatus = $('#issue_status_id').val();
            if (isContainKeyword(typeFieldValues, keyword) &&
                (parseInt(issueStatus) === 3 || parseInt(issueStatus) === 5)) {
                showError(keyword);
                return;
            }
            hideError();
            e.currentTarget.submit();
        });
    }

    function showError(keyword) {
        var errorMsg = `<div id="errorExplanation"><ul>
        <li>Cannot change status to Resolved/Closed when Type field contains `+ keyword + `</li>
        </ul></div>`;
        $('#issue-form').prepend(errorMsg);
        $("#errorExplanation")[0].scrollIntoView();
    }

    function hideError() {
        $('#errorExplanation').remove();
    }

    function isContainKeyword(values, keyword) {
        var isContains = false;
        for (let i = 0; i < values.length; i++) {
            if (values[i].toLowerCase() === keyword.toLowerCase()) {
                isContains = true;
                break;
            }
        }
        return isContains;
    }

    return {
        init: initSubmitEditIssueEvent
    }
})(jQuery);


$(document).ready(function () {
    if (typeof (customFieldTypeID) !== 'undefined' && typeof (customFieldTypeValueValidation) !== 'undefined'
        && customFieldTypeID !== '' && customFieldTypeValueValidation != '') {
        issueEditValidation.init(customFieldTypeID, customFieldTypeValueValidation);
    }
});