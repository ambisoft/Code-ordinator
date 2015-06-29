// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

(function()
{
    // Make array filled with all checked notes (on every check)
    function gatherNotes()
    {
        var selectedNotes = [];

        $('.note input[type=checkbox]:checked')
            .closest('.note').each(function()
            {
                selectedNotes.push($(this).data('id'));
            });

        return selectedNotes;
    }

    function selectAllNotes()
    {
        var check = true;
        if(gatherNotes().length == $('.note').length)
            check = false;
        $('.note input[type=checkbox]').prop('checked', check);
    }

    // Create checkboxes
    $('#all-notes').find('.note').append('<label><input type="checkbox" class="article"></label>');

    // Show menu
    $('#all-notes').find('.bar').find('.options').removeClass('visuallyhidden');

    // Bind functions
    $('#notes-check-all').click(selectAllNotes);
    $('#notes-delete-checked').click(function()
    {
        if(gatherNotes().length > 0)
            location.href = '/notes/' + JSON.stringify(gatherNotes()) + '/delete';
    });

})();
