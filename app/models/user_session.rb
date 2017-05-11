class UserSession < Authlogic::Session::Base
  logout_on_timeout true  # 设置timeout有效
end