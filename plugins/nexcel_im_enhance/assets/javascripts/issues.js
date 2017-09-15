$(document).ready(function () {
    HightlightNewlyUpdatedIssues('#FDEEE8');
    HightlightCriticalImpactIssues('#EAF7FF');
});

function HightlightNewlyUpdatedIssues(color){
    const HOURS_AS_LATEST = 24;
    var updates = $('tr.issue td.updated_on');
    var today = new Date();
    var diff = 60 * 60 * 1000 * HOURS_AS_LATEST;
    updates.each(function (i, issue) {
        var t = new Date($(issue).text());
        var msDiff = today - t;
        if (msDiff <= diff) {
            $(issue).parent().css('background-color', color);
        }
    });
}

function HightlightCriticalImpactIssues(color){
    var criticals = $('tr.issue td.priority:contains("Critical")');
    criticals.each(function(i, issue){
        $(issue).parent().css('background-color', color);
    });
}