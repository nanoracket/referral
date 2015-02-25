class User < ActiveRecord::Base
    belongs_to :referrer, :class_name => "User", :foreign_key => "referrer_id"
    has_many :referrals, :class_name => "User", :foreign_key => "referrer_id"
    
    attr_accessible :email

    validates :email, :uniqueness => true, :format => { :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i, :message => "Invalid email format." }
    validates :referral_code, :uniqueness => true

    before_create :create_referral_code
    after_create :send_welcome_email

    REFERRAL_STEPS = [
        {
            'count' => 1,
            "html" => "High<br>Five!",
            "class" => "two",
            "image" =>  ActionController::Base.helpers.asset_path("/assets/refer/high-five.jpeg")
        },
        {
            'count' => 10,
            "html" => "25% Off<br>Headphones",
            "class" => "three",
            "image" => ActionController::Base.helpers.asset_path("/assets/refer/25-off.jpg")
        },
        {
            'count' => 100,
            "html" => "SonicVR<br>Headphones",
            "class" => "four",
            "image" => ActionController::Base.helpers.asset_path("/assets/refer/headphones.jpg")
        },
        {
            'count' => 200,
            "html" => "Oculus Rift<br>DK2",
            "class" => "five",
            "image" => ActionController::Base.helpers.asset_path("/assets/refer/dk2-product.jpg")
        }
    ]

    private

    def create_referral_code
        referral_code = SecureRandom.hex(5)
        @collision = User.find_by_referral_code(referral_code)

        while !@collision.nil?
            referral_code = SecureRandom.hex(5)
            @collision = User.find_by_referral_code(referral_code)
        end

        self.referral_code = referral_code
    end

    def send_welcome_email
        UserMailer.delay.signup_email(self)
    end
end
