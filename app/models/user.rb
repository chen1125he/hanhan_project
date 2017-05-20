class User < ActiveRecord::Base

  has_one :user_picture,:dependent => :destroy, :as => :owner
  has_one :user_info


  validates_length_of :login, :minimum => 8

  acts_as_authentic do |c|
    c.logged_in_timeout = 30.minutes #30.minutes #session 30分 失效
    c.crypto_provider = Authlogic::CryptoProviders::Sha512 #密码的加密方式
  end

  def get_user_info
    info = self.user_info
    unless info.present?
      info = UserInfo.new(:nick_name => self.login)
      info.user = self
      info.save(:validate => false)
    end
    info
  end


end
