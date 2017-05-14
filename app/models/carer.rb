class Carer < CareCared

  belongs_to :UserInfo, :class_name => 'UserInfo'
  belongs_to :carer, :foreign_key => 'care_id', :dependent => destroy, :polymorphic => true
end