class Notice < ApplicationRecord

  validates :title, :presence => true

  SHOW_FLAG = {true => '显示', false => '不显示'}

  def get_date str = ' - '
    "#{self.show_from.try(:strftime, '%Y/%m/%d')}#{str}#{self.show_to.try(:strftime, '%Y/%m/%d')}"
  end

  def self.display_notice
    where(:show_flag => true).where('notices.show_from <= ? and notices.show_to >= ?', Time.now.strftime("%Y/%m/%d"), Time.now.strftime("%Y/%m/%d")).order(:updated_at => :desc).first
  end
end
