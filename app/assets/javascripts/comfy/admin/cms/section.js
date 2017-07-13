function remove_fields(link) {
        $(link).prev("input[type=hidden]").val("1");
        $(link).closest(".fields").hide();
        return false;
}

function append_fields(link, association, content) {
        var new_id = new Date().getTime();
        var regexp = new RegExp("new_" + association, "g");
        $(link).parents('.cms-section').children("ul.list").append(content.replace(regexp, new_id));
        return false;
}

function prepend_fields(link, association, content) {
        var new_id = new Date().getTime();
        var regexp = new RegExp("new_" + association, "g");
        $(link).parents('.cms-section').children("ul.list").prepend(content.replace(regexp, new_id));
        return false;
}
