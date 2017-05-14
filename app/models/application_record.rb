class ApplicationRecord < ActiveRecord::Base

  self.abstract_class = true

  PER = 10

  default_scope -> { where(:deleted => false) }

  def destroy
    return if self.blank?
    self.update_attribute(:deleted, true)
  end
end
