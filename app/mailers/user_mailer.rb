class UserMailer < ActionMailer::Base
    default from: 'noreply@example.com'

    def signup_email(user)
        @user = user
        @url = "https://referral-nanoracket.c9.io/"
        @twitter_message = "#Shaving is evolving. Excited for @harrys to launch."
        attachments.inline['logo.jpg'] = File.read("#{Rails.root}/app/assets/images/email/logo.jpg")
        attachments.inline['dk2.jpg'] = File.read("#{Rails.root}/app/assets/images/refer/dk2-product.jpg")
        attachments.inline['refer.jpg'] = File.read("#{Rails.root}/app/assets/images/email/refer.jpg")
        attachments.inline['facebook.jpg'] = File.read("#{Rails.root}/app/assets/images/email/facebook.jpg")
        attachments.inline['twitter.jpg'] = File.read("#{Rails.root}/app/assets/images/email/twitter.jpg")

        mail(:to => @user.email, :subject => "Thanks for signing up!")
    end
end
