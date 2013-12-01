require "customer_comm_recordx/engine"

module CustomerCommRecordx
  mattr_accessor :customer_class, :customer_autocomplete_path
  
  def self.customer_class
    @@customer_class.constantize
  end
end
