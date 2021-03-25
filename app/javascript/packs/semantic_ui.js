const ready = () => {
    $('.message .close').on('click', () => {
        $(this).closest('.message').hide();
    })

    $('.dropdown').dropdown();
}

$(document).ready(ready)
$(document).on('page:load', ready)
