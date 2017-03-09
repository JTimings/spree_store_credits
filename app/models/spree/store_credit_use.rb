class Spree::StoreCreditUse < ActiveRecord::Base
  belongs_to :store_credit, class_name: "Spree::StoreCredit"

  CATEGORY = {
    AFFILILATE:   { name: 'Referral',     xero_code: 410 },
    COMPENSATION: { name: 'Compensation', xero_code: 411 },
    PREPAID:      { name: 'Prepaid',      xero_code: 883 }
  }

end