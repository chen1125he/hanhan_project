class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  PER = 10
end
