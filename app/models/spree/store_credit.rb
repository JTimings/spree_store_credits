class Spree::StoreCredit < ActiveRecord::Base
  validates :amount, :presence => true, :numericality => true
  validates :reason, :presence => true
  validates :user, :presence => true
  if Spree.user_class
    belongs_to :user, :class_name => Spree.user_class.to_s
  else
    belongs_to :user
  end

  has_many :store_credit_uses

  def use_category
  	case self.reason.downcase
  	when /affiliate/
  		return 'AFFILILATE'
  	when /compensation/
  		return 'COMPENSATION'
  	when /prepaid/
  		return 'PREPAID'
  	else
  		return 'EMPLOYEEBENEFIT'
  	end  	
  end

end
