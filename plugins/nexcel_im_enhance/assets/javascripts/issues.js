$(document).ready(function () {
    HightlightCriticalImpactIssues('#EAF7FF');
    HightlightNewlyUpdatedIssues('#FDEEE8');
});

function HightlightNewlyUpdatedIssues(color){
    const HOURS_AS_LATEST = 24;
    var issues = $('tr.issue');
    var today = new Date();
    var diff = 60 * 60 * 1000 * HOURS_AS_LATEST;
    issues.each(function (i, issue) {
        var t = new Date($(issue).data("updatedon"));
        var msDiff = today - t;
        if (msDiff <= diff) {
            $(issue).css('background-color', color);
        }
    });
}

function HightlightCriticalImpactIssues(color){
    $('.priority-1').css('background-color', color);
}