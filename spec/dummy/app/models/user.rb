# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  email           :string(255)
#  provider        :string(255)
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  has_secure_password

  validates_uniqueness_of :email

  def self.from_omniauth(auth)
    find_by_provider_and_password_digest(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.password_digest = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end
end
