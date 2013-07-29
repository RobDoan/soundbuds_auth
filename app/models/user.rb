class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :authentications, :dependent => :destroy

  def customer_shopify_data
    {email: self.email}
  end

  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
    #self.first_name = omniauth['info']['first_name']
    #self.last_name = omniauth['info']['last_name']
    #self.phone_number = omniauth['info']['phone_number']
    if omniauth['provider'] == 'twitter'
      self.email = "twitter#{omniauth['uid']}@twitter.com"
    end
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

end
