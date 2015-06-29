module CustomerCommRecordx
  class CustomerCommRecord < ActiveRecord::Base
    attr_accessor :void_name, :reported_by_name, :via_noupdate     #for readonly field
           
    belongs_to :last_updated_by, :class_name => 'Authentify::User'    
    belongs_to :comm_category, :class_name => 'Commonx::MiscDefinition' 
    belongs_to :reported_by, :class_name => 'Authentify::User'   
    
    validates :subject, :contact_info, :via, :comm_date, :resource_string, :category, :presence => true
    validates :reported_by_id, :resource_id, :presence => true, :numericality => {:greater_than => 0}
    validates :content, :presence => true, :uniqueness => {:scope => [:category, :resource_id, :resource_string], :case_sensitive => false, :message => I18n.t('Duplicate Content')} 
    validates :comm_category_id, :numericality => {:greater_than => 0}, :if => 'comm_category_id.present?'
    validate :dynamic_validate
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'customer_comm_recordx_customer_comm_records')
      eval(wf) if wf.present?
    end
    
    scope :not_void, -> {where(:void => false)}
  end
end
