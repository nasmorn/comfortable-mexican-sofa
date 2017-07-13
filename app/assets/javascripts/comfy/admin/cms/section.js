function remove_fields(link) {
        $(link).prev("input[type=hidden]").val("1");
        $(link).closest(".fields").hide();
        return false;
}

function append_fields(link, association, content) {
        var new_id = new Date().getTime();
        var regexp = new RegExp("new_" + association, "g");
        list = $(link).parents('.cms-section').children("ul.list")
        list.append(content.replace(regexp, new_id));
        window.CMS.sort_section(list)
        return false;
}

function prepend_fields(link, association, content) {
        var new_id = new Date().getTime();
        var regexp = new RegExp("new_" + association, "g");
        list = $(link).parents('.cms-section').children("ul.list")
        list.prepend(content.replace(regexp, new_id));
        window.CMS.sort_section(list)
        return false;
}
