class UserMailer < ActionMailer::Base
    default from: 'marketing@sonicvr.com'

    def signup_email(user)
        @user = user
        @url = "https://referral-nanoracket.c9.io/"
        @twitter_message = "#VirtualReality. Excited for @sonicvr to launch."
        attachments.inline['sonicvrlogo.png'] = File.read("#{Rails.root}/app/assets/images/email/sonicvrlogo.png")
        attachments.inline['dk2.jpg'] = File.read("#{Rails.root}/app/assets/images/refer/dk2-product.jpg")
        attachments.inline['refer.jpg'] = File.read("#{Rails.root}/app/assets/images/email/refer.jpg")
        attachments.inline['facebook.jpg'] = File.read("#{Rails.root}/app/assets/images/email/facebook.jpg")
        attachments.inline['twitter.jpg'] = File.read("#{Rails.root}/app/assets/images/email/twitter.jpg")

        mail(:to => @user.email, :subject => "Thanks for signing up!")
    end
end
