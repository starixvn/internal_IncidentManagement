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
});

function ApplySelect2ToLicensee(){
    $("#issue_custom_field_values_21").select2();
}