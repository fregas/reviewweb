  module ReviewsHelper
    def show_stars(number_of_stars)
      html = '' 
      for i in (1..5)
        if number_of_stars == nil || i <= number_of_stars 
          html << image_tag ('star.png')
        else
          html << image_tag ('blankstar.png')
        end
      end

      return html.html_safe
    end

    def review_widget(review)
      html = ''

      for i in (1..5)
        script = "do_rating(#{i.to_s}); "
        id = "review_star_#{i.to_s}"
        link = link_to_function  image_tag ('blankstar.png', :id => id, :border => "0" ) , script 
        html << link  
      end

      html << hidden_field(review, :rating, :class => 'review_widget_hidden')


      return html.html_safe
    end
    
  end
