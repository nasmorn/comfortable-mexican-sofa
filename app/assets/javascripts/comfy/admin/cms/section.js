function remove_fields(link) {
        $(link).prev("input[type=hidden]").val("1");
        $(link).closest(".fields").hide();
        return false;
}

function add_fields(link, association, content) {
        var new_id = new Date().getTime();
        var regexp = new RegExp("new_" + association, "g");
        $(link).nextAll("ul").append(content.replace(regexp, new_id));
        return false;
}