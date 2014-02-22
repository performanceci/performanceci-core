class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  def self.from_omniauth(auth, current_user)
    puts auth
    if find_or_create_by.user.blank?
      user = current_user.nil? ? User.where('email = ?', auth["info"]["email"]).first : current_user
      if user.blank?
       user = User.new
       user.password = Devise.friendly_token[0,10]
       user.name = auth.info.name
       user.email = auth.info.email
     end
   end
  end

  def find_or_create_by(payload)
    attrs = attributes_from(payload)
    user = User.find_by_github_id(attrs['github_id'])
    user ? user.update_attributes(attrs) : user = User.create!(attrs)
    user
  end

  def attributes_from(payload)
    {
      'name'               => payload['info']['name'],
      'email'              => payload['info']['email'],
      'login'              => payload['info']['nickname'],
      'github_id'          => payload['uid'].to_i,
      'github_oauth_token' => payload['credentials']['token'],
      'gravatar_id'        => payload['extra']['raw_info']['gravatar_id']
    }
  end

end
