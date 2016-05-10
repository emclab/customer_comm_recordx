require 'rails_helper'

RSpec.describe "LinkTests", type: :request do
  describe "GET /customer_comm_recordx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link',
         'right-span#'         => '2', 
               'left-span#'         => '6', 
               'offset#'         => '2',
               'form-span#'         => '4'
        }
    before(:each) do
      config_entry = FactoryGirl.create(:engine_config, :engine_name => 'rails_app', :engine_version => nil, :argument_name => 'SESSION_TIMEOUT_MINUTES', :argument_value => 30)
      
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
        :sql_code => "CustomerCommRecordx::CustomerCommRecord.order('comm_date DESC')")
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
      @cust = FactoryGirl.create(:kustomerx_customer, :zone_id => z.id, :sales_id => @u.id, :last_updated_by_id => @u.id, :quality_system_id => qs.id, :addresses => [add])
      @ccate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_comm_category', :active => true, :last_updated_by_id => @u.id)
      @ccate1 = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'new', :active => true, :last_updated_by_id => @u.id)
      @ccate2 = FactoryGirl.create(:commonx_misc_definition, :for_which => 'quality_system', :name => 'nnew', :active => true, :last_updated_by_id => @u.id)
                                                                    
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login'
    end
    
    it "should display customer_comm_record index page" do
      visit customer_comm_recordx.customer_comm_records_path
      expect(page).to have_content('Communication Records')
    end
    
    it "should work with links on customer comm record index page" do
      crecord = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id, :comm_category_id => @ccate.id, :via => 'phone')
      visit customer_comm_recordx.customer_comm_records_path
      click_link crecord.id.to_s
      visit customer_comm_recordx.customer_comm_records_path(:customer_id => @cust.id)
      click_link 'New Customer Comm Record'
      #visit customer_comm_recordx.customer_comm_records_path
      #click_link 'Back'
      visit customer_comm_recordx.customer_comm_records_path
      click_link 'Edit'
    end
    
    it "should create/edit comm record" do
      crecord = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id, :comm_category_id => @ccate.id, :via => 'phone')
      visit customer_comm_recordx.customer_comm_records_path(:customer_id => @cust.id)
      #save_and_open_page
      click_link 'Edit'
      #save_and_open_page
      expect(page).to have_content('Update Communication Record')
      fill_in 'customer_comm_record_subject', :with => 'a new subject'
      click_button 'Save'
      visit customer_comm_recordx.customer_comm_records_path(:customer_id => @cust.id)
      save_and_open_page
      expect(page).to have_content('a new subject')
      #bad data
      visit customer_comm_recordx.customer_comm_records_path(:customer_id => @cust.id)
      click_link 'Edit'
      fill_in 'customer_comm_record_content', :with => ''
      fill_in 'customer_comm_record_subject', :with => 'a sucker change'
      click_button 'Save'
      visit customer_comm_recordx.customer_comm_records_path(:customer_id => @cust.id)
      expect(page).not_to have_content('a sucker change')
      
      #new
      visit customer_comm_recordx.customer_comm_records_path(:customer_id => @cust.id)
      click_link 'New Customer Comm Record'
      expect(page).to have_content('New Communication Record')
      fill_in 'customer_comm_record_content', :with => 'content'
      fill_in 'customer_comm_record_subject', :with => 'a new sucker'
      select('phone', :from => 'customer_comm_record_via')
      select(@ccate.name, :from => 'customer_comm_record_comm_category_id')
      fill_in 'customer_comm_record_comm_date', :with => Date.today
      fill_in 'customer_comm_record_contact_info', :with => 'a guy'
      click_button 'Save'
      save_and_open_page
      visit customer_comm_recordx.customer_comm_records_path(:customer_id => @cust.id)      
      expect(page).to have_content('a new sucker')
      #bad data
      visit customer_comm_recordx.customer_comm_records_path(:customer_id => @cust.id)
      click_link 'New Customer Comm Record'
      expect(page).to have_content('New Communication Record')
      fill_in 'customer_comm_record_content', :with => ''
      fill_in 'customer_comm_record_subject', :with => 'a new new sucker'
      select('phone', :from => 'customer_comm_record_via')
      select(@ccate.name, :from => 'customer_comm_record_comm_category_id')
      fill_in 'customer_comm_record_contact_info', :with => 'a guy'
      fill_in 'customer_comm_record_comm_date', :with => Date.today
      click_button 'Save'
      visit customer_comm_recordx.customer_comm_records_path(:customer_id => @cust.id)
      expect(page).not_to have_content('a new new sucker')
    end
    
    it "should show customer_comm_record page" do
      crecord = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id, :comm_category_id => @ccate.id, :via => 'phone')
      visit customer_comm_recordx.customer_comm_record_path(@cust, crecord)
      #save_and_open_page
      expect(page).to have_content('Communication Record Info')
    end
  end
end
