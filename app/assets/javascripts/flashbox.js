/**
 * Created by schizohatter on 07.06.15.
 */

(function()
{
    var flashbox = $('#flashbox');

    // Show flashbox, add close buttons
        flashbox.css('display', 'block')
            .find('.flash-message').append('<span class="close-button">&#xf00d;</span>')
            .find('.close-button').click(function()
            {
                $(this).parent().css('display', 'none');
            });

    // Animate flashbox
    function popup(offset)
    {
        if(offset <= flashesLength - 1)
        {
            $(flashes[offset]).animate({opacity: 1, bottom: 0}, 350,
                function()
                {
                    offset += 1;
                    popup(offset);
                });
        }
    }

    flashbox.find('.flash-message').css({ opacity: 0, bottom: -20 });

    var flashes = flashbox.find('.flash-message');
    var flashesLength = flashes.length;
    var offset = 0;

    popup(offset);

}).call(this);
