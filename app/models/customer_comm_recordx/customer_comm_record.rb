module CustomerCommRecordx
  class CustomerCommRecord < ActiveRecord::Base
    attr_accessor :customer_name, :void_name, :reported_by_name, :via_noupdate     #for readonly field
    attr_accessible :comm_category_id, :comm_date, :contact_info, :content, :customer_id, :last_updated_by_id, :reported_by_id, 
                    :subject, :via, :customer_name_autocomplete, 
                    :customer_name, :void_name, :void, :reported_by_name, :via_noupdate,
                    :as => :role_new
    attr_accessible :comm_category_id, :comm_date, :contact_info, :content, :customer_id, :last_updated_by_id, :reported_by_id, 
                    :subject, :via, :void, 
                    :customer_name, :void_name, :reported_by_name, :via_noupdate,
                    :as => :role_update  
                    
    attr_accessor :customer_id_s, :start_date_s, :end_date_s, :zone_id_s, :sales_id_s, :comm_category_id_s, :via_s, :time_frame_s
    attr_accessible :customer_id_s, :start_date_s, :end_date_s,:zone_id_s, :sales_id_s, :comm_category_id_s, :via_s, :time_frame_s, 
                    :as => :role_search_stats
                    
    belongs_to :customer, :class_name => CustomerCommRecordx.customer_class.to_s
    belongs_to :last_updated_by, :class_name => 'Authentify::User'    
    belongs_to :comm_category, :class_name => 'Commonx::MiscDefinition' 
    belongs_to :reported_by, :class_name => 'Authentify::User'   
    has_many :logs, :class_name => "Commonx::Log" 
    
    validates :subject, :contact_info, :reported_by_id, :via, :comm_category_id, :comm_date, :customer_id, :presence => true
    validates :reported_by_id, :comm_category_id, :customer_id, :presence => true, :numericality => {:greater_than => 0}
    validates :content, :presence => true, :uniqueness => {:scope => :customer_id, :case_sensitive => false, :message => I18n.t('Duplicate Content')}  
    
    def customer_name_autocomplete
      self.customer.try(:name)
    end

    def customer_name_autocomplete=(name)
      self.customer = CustomerCommRecordx.customer_class.find_by_name(name) if name.present?
    end
    
    scope :not_void, where(:void => false)
  end
end
