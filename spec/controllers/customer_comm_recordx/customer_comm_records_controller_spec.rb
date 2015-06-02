require 'rails_helper'

module CustomerCommRecordx
  RSpec.describe CustomerCommRecordsController, type: :controller do
    routes {CustomerCommRecordx::Engine.routes}
    before(:each) do
      expect(controller).to receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'customerx', :engine_version => nil, :argument_name => 'customer_comm_record_show_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('cusotmer_comm_record_show_view', 'cusotmer_comm_recordx')) 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'customerx', :engine_version => nil, :argument_name => 'customer_comm_record_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('cusotmer_comm_record_index_view', 'cusotmer_comm_recordx')) 
      config = FactoryGirl.create(:engine_config, :engine_name => 'customer_comm_recordx', :engine_version => nil, :argument_name => 'contact_via', :argument_value => 'phone, email, fax, meeting')
    end
  
    before(:each) do
      @cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
      @c_cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_comm_record')
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'user', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      ur1 = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul1 = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u1 = FactoryGirl.create(:user, :user_levels => [ul1], :user_roles => [ur1], :email => 'newnew@a.com', :login => 'newnew', :name => 'verynew')
      
      session[:user_role_ids] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id).user_role_ids
    end
    render_views
    
    describe "GET 'index'" do
      it "returns customer comm records for user for his own customers'" do
        
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "CustomerCommRecordx::CustomerCommRecord.where(:void => false).where('comm_date > ?', 2.years.ago).
          where(:customer_id => Kustomerx::Customer.where(:sales_id => session[:user_id]).select('id')).
          order('comm_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id, :sales_id => @u.id)
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id, :comm_category_id => @c_cate.id)
        get 'index', { :customer_id => cust.id}
        expect(assigns(:customer_comm_records)).to eq([rec])
      end
      
      it "returns customer comm records for manager users for customers his group" do
     
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "CustomerCommRecordx::CustomerCommRecord.where(:void => false).where('comm_date > ?', 2.years.ago).
          where(:customer_id => Kustomerx::Customer.where(:sales_id => Authentify::UserLevel.where(:sys_user_group_id => session[:user_privilege].user_group_ids).select('user_id')).select('id')).
          order('comm_date DESC')")
        session[:employee] = true
        session[:user_id] = @u1.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u1.id)
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id, :sales_id => @u.id)
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id, :comm_category_id => @c_cate.id)
        get 'index', { :customer_id => cust.id}
        expect(assigns(:customer_comm_records)).to eq([rec])
      end
      
      it "return customer comm records in the same zone for managers" do
        
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "CustomerCommRecordx::CustomerCommRecord.where(:void => false).where('comm_date > ?', 2.years.ago).
          where(:customer_id => Kustomerx::Customer.where(:sales_id => Authentify::UserLevel.joins(:sys_user_group).
          where(:authentify_sys_user_groups => {:zone_id => session[:user_privilege].user_zone_ids}).select('user_id')).select('id')).
          order('comm_date DESC')")
        
        session[:employee] = true
        session[:user_id] = @u1.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u1.id)
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id, :sales_id => @u.id)
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id, :comm_category_id => @c_cate.id)
        get 'index'
        expect(assigns(:customer_comm_records)).to eq([rec])
      end
      
      it "return customer comm records in the same role for managers" do
        
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "CustomerCommRecordx::CustomerCommRecord.where(:void => false).where('comm_date > ?', 2.years.ago).
          where(:customer_id => Kustomerx::Customer.where(:sales_id => Authentify::UserRole.where(:role_definition_id => session[:user_privilege].user_role_ids).select('user_id')).select('id')).
          order('comm_date DESC')")        
        session[:employee] = true
        session[:user_id] = @u1.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u1.id)
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id, :sales_id => @u.id)
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id, :comm_category_id => @c_cate.id)
        get 'index'
        expect(assigns(:customer_comm_records)).to eq([rec])
      end
      
      it "should return @customer's comm record for user with right" do
        
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "CustomerCommRecordx::CustomerCommRecord.where(:void => true)")  #none returned if this sql_code is executed
        user_access1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'kustomerx_customers', :role_definition_id => @role.id, :rank => 40)
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id, :comm_category_id => @c_cate.id, :void => false)
        get 'index', { :customer_id => cust.id}
        #expect(response).to be_success
        expect(assigns(:customer_comm_records)).to eq([])
      end
=begin      
      it "should redirect if there is no index right" do
        
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id, :comm_category_id => @c_cate.id, :void => false)
        get 'index', { :customer_id => cust.id}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=index and resource=customer_comm_recordx/customer_comm_records")
      end
=end
    end
  
    describe "GET 'new'" do
      it "returns http success for users without customer id" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        rec = FactoryGirl.attributes_for(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id)
        get 'new', { :customer_id => cust.id}
        expect(response).to be_success
      end
      
      it "should http success for users with customer_id" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        rec = FactoryGirl.attributes_for(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id)
        get 'new', { :customer_id => cust.id}
        expect(response).to be_success
      end

=begin      
      it "should reject users withour rights" do
        user_access = FactoryGirl.create(:user_access, :action => 'unknown-create', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        rec = FactoryGirl.attributes_for(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id)
        get 'new', { :customer_id => cust.id}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=new and resource=customer_comm_recordx/customer_comm_records")
      end
=end
    end
  
    describe "GET 'create'" do
      it "should redirect to new page for user without customer_id when customer name not selected" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        rec = FactoryGirl.attributes_for(:customer_comm_recordx_customer_comm_record, :customer_id => nil)
        get 'create', { :customer_comm_record => rec, :customer_name_autocomplete => nil, :customer_id => cust.id}
        #expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Customer Communication Record Saved!")
        expect(response).to render_template("new")
      end
      
      it "should create new record for user without customer id but selecting the customer name" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id, :name => 'tester')
        rec = FactoryGirl.attributes_for(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id)
        get 'create', { :customer_comm_record => rec, :customer_name_autocomplete => cust.name, :customer_id => cust.id }
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should create record for user w/ customer_id" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        rec = FactoryGirl.attributes_for(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id)
        get 'create', { :customer_comm_record => rec, :customer_id => cust.id}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
    end
  
    describe "GET 'edit'" do
      it "returns http success for users with right" do
        user_access1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'kustomerx_customers', :role_definition_id => @role.id, :rank => 1, :sql_code => '')
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id)
        get 'edit', { :id => rec.id, :customer_id => cust.id}
        expect(response).to be_success
      end
=begin      
      it "should redirect for users without right" do
        user_access = FactoryGirl.create(:user_access, :action => 'unknown-update', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id)
        get 'edit', { :id => rec.id, :customer_id => cust.id}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=edit and resource=customer_comm_recordx/customer_comm_records")
      end
=end
    end
  
    describe "GET 'update'" do
      it "should update for users with right" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "", :masked_attrs => ['=content'])
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id)
        get 'update', { :customer_id => cust.id, :id => rec.id, :customer_comm_record => {:subject => 'new subject'}}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit for data error" do
        user_access1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'kustomerx_customers', :role_definition_id => @role.id, :rank => 1, :sql_code => '')
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "", :masked_attrs => ['=content'])
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id)
        get 'update', { :customer_id => cust.id, :id => rec.id, :customer_comm_record => {:subject => ''}}
        expect(response).to render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "should show customer comm record" do        
        user_access1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'kustomerx_customers', :role_definition_id => @role.id, :rank => 1, :sql_code => '')
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "", :masked_attrs => ['=content'])        
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id, :comm_category_id => @c_cate.id)
        get 'show', { :customer_id => cust.id, :id => rec.id}
        expect(response).to be_success
      end
    end
  
  end
end
