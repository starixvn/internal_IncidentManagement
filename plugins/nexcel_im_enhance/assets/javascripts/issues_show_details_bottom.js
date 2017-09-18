$(document).ready(function () {
    var $childGravatar = $(".gravatar-with-child .gravatar")[1];
    $($childGravatar).detach().prependTo($(".assigned-to > div.value")[0]);

    $($childGravatar).attr("width", "14");
    $($childGravatar).attr("height", "14");
});