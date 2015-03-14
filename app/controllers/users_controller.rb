class UsersController < ApplicationController
    before_filter :skip_first_page, :only => :new

    def new
        @bodyId = 'home'
        @is_mobile = mobile_device?

        @user = User.new

        respond_to do |format|
            format.html # new.html.erb
        end
    end

    def create
        # Get user to see if they have already signed up
        @user = User.find_by_email(params[:user][:email]);
            
        # If user doesnt exist, make them, and attach referrer
        if @user.nil?

            cur_ip = IpAddress.find_by_address(request.env['HTTP_X_FORWARDED_FOR'])

            if !cur_ip
                cur_ip = IpAddress.create(
                    :address => request.env['HTTP_X_FORWARDED_FOR'],
                    :count => 0
                )
            end

            if cur_ip.count > 2
                return redirect_to root_path
            else
                cur_ip.count = cur_ip.count + 1
                cur_ip.save
            end

            @user = User.new(:email => params[:user][:email])

            @referred_by = User.find_by_referral_code(cookies[:h_ref])

            puts '------------'
            puts @referred_by.email if @referred_by
            puts params[:user][:email].inspect
            puts request.env['HTTP_X_FORWARDED_FOR'].inspect
            puts '------------'

            if !@referred_by.nil?
                @user.referrer = @referred_by
            end

            @user.save
        end

        # Send them over refer action
        respond_to do |format|
            if !@user.nil?
                cookies[:h_email] = { :value => @user.email }
                UserMailer.signup_email(@user).deliver
                format.html { redirect_to '/refer-a-friend' }
                
            else
                format.html { redirect_to root_path, :alert => "Something went wrong!" }
                puts 'here'
            end
        end
    end

    def refer
        email = cookies[:h_email]

        @bodyId = 'refer'
        @is_mobile = mobile_device?

        @user = User.find_by_email(email)

        respond_to do |format|
            if !@user.nil?
                format.html #refer.html.erb
            else
                format.html { redirect_to root_path, :alert => "Something went wrong!" }
            end
        end
    end

    def policy
          
    end  
    
    def preview
    #    client = SendGrid::Client.new(api_user: 'app34191801@heroku.com', api_key: 'tplkciuq')
    #    @user = User.find(17)
     #   @twitter_message = "#Shaving is evolving. Excited for @harrys to launch."
      #  UserMailer.signup_email(@user).deliver
=begin
        #email = SendGrid::Mail.new do |m|
  m.to = @user.email
  m.from = 'noreply@sink.sendgrid.com'
  m.subject = "Welcome <%= @user.email %>"
  m.text = "Hello,\n\nThis is a test message from SendGrid.    We have sent this to you because you requested a test message be sent from your account.\n\nThis is a link to google.com: http://www.google.com\nThis is a link to apple.com: http://www.apple.com\nThis is a link to sendgrid.com: http://www.sendgrid.com\n\nThank you for reading this test message.\n\nLove,\nYour friends at SendGrid"
  m.html = "<table style=\"border: solid 1px #000; background-color: #666; font-family: verdana, tahoma, sans-serif; color: #fff;\"> <tr> <td> <h2>Hello,</h2> <p>This is a test message from SendGrid.    We have sent this to you because you requested a test message be sent from your account.</p> <a href=\"http://www.google.com\" target=\"_blank\">This is a link to google.com</a> <p> <a href=\"http://www.apple.com\" target=\"_blank\">This is a link to apple.com</a> <p> <a href=\"http://www.sendgrid.com\" target=\"_blank\">This is a link to sendgrid.com</a> </p> <p>Thank you for reading this test message.</p> Love,<br/> Your friends at SendGrid</p> <p> <img src=\"http://cdn1.sendgrid.com/images/sendgrid-logo.png\" alt=\"SendGrid!\" /> </td> </tr> </table>"

end
   puts client.send(email)
=end
    end

    def redirect
        redirect_to root_path, :status => 404
    end

    private 

    def skip_first_page
        if !Rails.application.config.ended
            email = cookies[:h_email]
            if email and !User.find_by_email(email).nil?
                redirect_to '/refer-a-friend'
            else
                cookies.delete :h_email
            end
        end
    end

end
