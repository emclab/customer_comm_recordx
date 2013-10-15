require "customer_comm_recordx/engine"

module CustomerCommRecordx
  mattr_accessor :customer_class
  
  def self.customer_class
    @@customer_class.constantize
  end
end
