class Careder < CareCared

  belongs_to :careder, :foreign_key => 'cared_id', :dependent => destroy, :polymorphic => true

  belongs_to :carer, :foreign_key => 'care_id', :dependent => destroy, :polymorphic => true
end