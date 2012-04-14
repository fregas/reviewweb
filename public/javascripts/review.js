

function do_rating(rating) 
{
    for (i = 1; i<= 5;i++)
    {
        if (i <= rating)
          file = "star.png";
        else
          file = "blankstar.png";

        var star = $("#review_star_" + i);
        star.attr("src","/images/" + file);

        $(".review_widget_hidden").val(rating);
    }

}
