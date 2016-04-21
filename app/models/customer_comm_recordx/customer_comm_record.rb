module CustomerCommRecordx
  class CustomerCommRecord < ActiveRecord::Base
    attr_accessor :void_name, :reported_by_name, :via_noupdate     #for readonly field
           
    belongs_to :last_updated_by, :class_name => 'Authentify::User'    
    belongs_to :comm_category, :class_name => 'Commonx::MiscDefinition' 
    belongs_to :reported_by, :class_name => 'Authentify::User'  
    belongs_to :customer, :class_name => CustomerCommRecordx.customer_class.to_s 
    belongs_to :followup_to, :class_name => 'CustomerCommRecordx::CustomerCommRecord', :foreign_key => 'followup_to_id'
    has_many :followups, :class_name => 'CustomerCommRecordx::CustomerCommREcord', :foreign_key => 'followup_to_id'
    
    validates :subject, :contact_info, :via, :comm_date, :customer_id, :fort_token, :presence => true
    validates :reported_by_id, :customer_id, :presence => true, :numericality => {:greater_than => 0}
    validates :content, :presence => true, :uniqueness => {:scope => :customer_id, :case_sensitive => false, :message => I18n.t('Duplicate Content')} 
    validates :comm_category_id, :numericality => {:greater_than => 0}, :if => 'comm_category_id.present?'
    validates :followup_to_id, :numericality => {:greater_than => 0}, :if => 'followup_to_id.present?'
    validate :dynamic_validate
    
    default_scope {where(fort_token: Thread.current[:fort_token])}
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', self.fort_token, 'customer_comm_recordx_customer_comm_records')
      eval(wf) if wf.present?
    end
    
    scope :not_void, -> {where(:void => false)}
  end
end
