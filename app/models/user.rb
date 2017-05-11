class User < ActiveRecord::Base

  has_one :user_picture,:dependent => :destroy, :as => :owner


  validates_length_of :login, :minimum => 8

  acts_as_authentic do |c|
    c.logged_in_timeout = 30.minutes #30.minutes #session 30分 失效
    c.crypto_provider = Authlogic::CryptoProviders::Sha512 #密码的加密方式
  end
end
