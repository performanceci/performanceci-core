
require 'bcrypt'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  def self.from_omniauth(payload, current_user)
    puts payload
    user = User.find_by_email(payload['info']['email'])
    if User.find_by_email(payload['info']['email']).blank?
      user = User.new
      user.password = Devise.friendly_token[0,10]
      user.name = payload['info']['name']
      user.email = payload['info']['email']
      user.github_id = payload['uid'].to_i
      user.github_oauth_token = payload['credentials']['token']
      user.gravatar_id = payload['extra']['raw_info']['gravatar_id']
      user.save
    end
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

  def github_client
    Octokit::Client.new :access_token => github_oauth_token
  end

end
