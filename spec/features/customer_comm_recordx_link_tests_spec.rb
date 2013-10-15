require 'spec_helper'

describe "LinkTests" do
  describe "GET /customer_comm_recordx_link_tests" do
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      config = FactoryGirl.create(:engine_config, :engine_name => 'customer_comm_recordx', :engine_version => nil, :argument_name => 'contact_via', :argument_value => 'phone, email, fax, meeting')
      qs = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_qs')
      add = FactoryGirl.create(:kustomerx_address)
      #ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ua9 = FactoryGirl.create(:user_access, :action => 'update_customer_comm_category', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua10 = FactoryGirl.create(:user_access, :action => 'create_customer_comm_category', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua11 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "CustomerCommRecordx::CustomerCommRecord.joins(:customer).
        where(:kustomerx_customers => {:sales_id => session[:user_id]}).
        order('comm_date DESC')")
      ua12 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua13 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua14 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua15 = FactoryGirl.create(:user_access, :action => 'create_customer_comm_record', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua151 = FactoryGirl.create(:user_access, :action => 'index_customer_comm_category', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Commonx::MiscDefinition.
                     where(:active => true).order('ranking_index')") 
      ua = FactoryGirl.create(:user_access, :action => 'index_customer_status', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Commonx::MiscDefinition.
                     where(:active => true).order('ranking_index')")
      ua152 = FactoryGirl.create(:user_access, :action => 'index_quality_system', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Commonx::MiscDefinition.
                     where(:active => true).order('ranking_index')")
      ua1 = FactoryGirl.create(:user_access, :action => 'update_customer_status', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua17 = FactoryGirl.create(:user_access, :action => 'update_customer_status', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua18 = FactoryGirl.create(:user_access, :action => 'create_customer_status', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua19 = FactoryGirl.create(:user_access, :action => 'update_quality_system', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua20 = FactoryGirl.create(:user_access, :action => 'create_quality_system', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua23 = FactoryGirl.create(:user_access, :action => 'update_customer_comm_category', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua24 = FactoryGirl.create(:user_access, :action => 'create_customer_comm_category', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "") 
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur], :login => 'thistest', :password => 'password', :password_confirmation => 'password')
      lsource = FactoryGirl.create(:commonx_misc_definition, :for_which => 'sales_lead_source')
      @cate2 = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'newnew cate', :last_updated_by_id => @u.id)
      @cust = FactoryGirl.create(:kustomerx_customer, :zone_id => z.id, :sales_id => @u.id, :last_updated_by_id => @u.id, :quality_system_id => qs.id, :address => add)
      @ccate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_comm_category', :active => true, :last_updated_by_id => @u.id)
      @ccate1 = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'new', :active => true, :last_updated_by_id => @u.id)
      @ccate2 = FactoryGirl.create(:commonx_misc_definition, :for_which => 'quality_system', :name => 'nnew', :active => true, :last_updated_by_id => @u.id)
      @crecord = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id, :comm_category_id => @ccate.id)
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'kustomerx', :engine_version => nil, :argument_name => 'customer_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('customer_index_view', 'customerx')) 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'customer_comm_recordx', :engine_version => nil, :argument_name => 'customer_comm_record_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('cusotmer_comm_record_index_view', 'customerx')) 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'customer_comm_recordx', :engine_version => nil, :argument_name => 'customer_comm_record_log_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('customer_comm_record_log_index_view', 'customerx')) 
      
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'kustomerx', :engine_version => nil, :argument_name => 'customer_show_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('customer_show_view', 'customerx')) 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'customer_comm_recordx', :engine_version => nil, :argument_name => 'customer_comm_record_show_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('cusotmer_comm_record_show_view', 'customerx')) 
                                                                           
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login'
    end
    
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit customer_comm_records_path
      page.should have_content('Comm Records')
    end
    
    it "should display customer_comm_record index page" do
      visit customer_comm_records_path
      page.should have_content('Customer Comm Records')
    end
    
    it "should work with links on customer comm record index page" do
      visit customer_comm_records_path
      click_link @crecord.id.to_s
      visit customer_comm_records_path
      click_link 'New Customer Comm Record'
      #visit customer_comm_records_path
      #click_link 'Back'
      visit customer_comm_records_path
      click_link 'Edit'
    end
    
    it "should display comm record edit page" do
      visit edit_customer_comm_record_path(@cust, @crecord)
      page.should have_content('修改客户联系记录')
    end
    
    it "should show customer_comm_record page" do
      visit customer_comm_record_path(@cust, @crecord)
      page.should have_content('客户交流记录内容')
    end
  end
end
