  module CaptchaHelper  
    
      def get_rand
        num = rand(4)
        session[:captcha] = num
        render :text => num.to_s
      end

      def captcha_passed?
         params[:captcha].to_s == session[:captcha].to_s 
      end 

      def captcha_failed?
        !captcha_passed?
      end

  end

