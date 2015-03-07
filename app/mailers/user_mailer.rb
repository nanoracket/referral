class UserMailer < ActionMailer::Base
    default from: 'nanoracket@gmail.com'

    def signup_email(user)
        @user = user
        @url = "https://referral-nanoracket.c9.io"
        @twitter_message = "#Shaving is evolving. Excited for @harrys to launch."

        mail(:to => user.email, :subject => "Thanks for signing up!")
    end
end
