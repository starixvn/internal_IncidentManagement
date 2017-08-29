$(document).ready(function () {
    // Re-arrange in home page
    $(".news.box").detach().appendTo('.splitcontentleft');

    // Add Select2 to project search
    $("#quick-search select").select2();

    // Remove DMSF upload button
    $(".dmsf_uploader").remove();

    $(".dmsf-approvalworkflows").addClass("icon");

    ApplySelect2ToLicensee();

    $("#content .contextual:first a").on("click", function () {
        ApplySelect2ToLicensee();
    });
});

function ApplySelect2ToLicensee(){
    $("#issue_custom_field_values_21").select2();
}