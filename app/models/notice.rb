class Notice < ApplicationRecord

  validates :title, :presence => true

  SHOW_FLAG = {true => '显示', false => '不显示'}
end
