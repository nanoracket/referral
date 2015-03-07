class UserMailer < ActionMailer::Base
    default from: 'marketing@sonicvr.com'

    def signup_email(user)
        @user = user
        @url = "heroku.com"
        @twitter_message = "#Shaving is evolving. Excited for @harrys to launch."

        mail(:to => user.email, :subject => "Thanks for signing up!")
    end
end
