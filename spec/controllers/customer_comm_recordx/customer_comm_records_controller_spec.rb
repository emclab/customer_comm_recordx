require 'rails_helper'

module CustomerCommRecordx
  RSpec.describe CustomerCommRecordsController, type: :controller do
    routes {CustomerCommRecordx::Engine.routes}
    before(:each) do
      expect(controller).to receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
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
      @u1 = FactoryGirl.create(:user, :user_levels => [ul1], :user_roles => [ur1], :email => 'newnew@a.com', :login => 'newnew112', :name => 'verynew')
      
      @cust = FactoryGirl.create(:kustomerx_customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        
      session[:user_role_ids] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id).user_role_ids
      session[:fort_token] = @u.fort_token
    end
    render_views
    
    describe "GET 'index'" do
      it "returns customer comm records for user for his own customers'" do
        
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "CustomerCommRecordx::CustomerCommRecord.joins(:customer).where('customer_comm_recordx_customer_comm_records.void = ?', false).where('customer_comm_recordx_customer_comm_records.comm_date > ?', 2.years.ago).
          where('kustomerx_customers.sales_id = ?', session[:user_id]).
          order('comm_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        cust = FactoryGirl.create(:kustomerx_customer, :name => 'a new one', :short_name => 'a new', :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id, 
                                  :sales_id => @u.id)
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => cust.id, :comm_category_id => @c_cate.id, :reported_by_id => @u.id, :comm_date => Date.today)
        get 'index', { :customer_id => cust.id}
        expect(assigns(:customer_comm_records)).to match_array([rec])
      end
      
      it "returns customer comm records for category'" do       
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "CustomerCommRecordx::CustomerCommRecord.joins(:customer).where('customer_comm_recordx_customer_comm_records.void = ?', false).where('customer_comm_recordx_customer_comm_records.comm_date > ?', 2.years.ago).
          order('comm_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        rec1 = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id, :comm_category_id => @c_cate.id + 1, :reported_by_id => @u.id, :comm_date => Date.today,
                                  :content => ' a new')
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id, :comm_category_id => @c_cate.id, :reported_by_id => @u.id, :comm_date => Date.today)
        get 'index', { :comm_category_id => @c_cate.id}
        expect(assigns(:customer_comm_records)).to match_array([rec])
      end
    
      it "returns customer comm records for the via'" do       
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "CustomerCommRecordx::CustomerCommRecord.joins(:customer).where('customer_comm_recordx_customer_comm_records.void = ?', false).where('customer_comm_recordx_customer_comm_records.comm_date > ?', 2.years.ago).
          order('comm_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        rec1 = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id, :comm_category_id => @c_cate.id + 1, :reported_by_id => @u.id, :comm_date => Date.today,
                                  :content => ' a new', :via => 'phone')
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id, :comm_category_id => @c_cate.id, :reported_by_id => @u.id, :comm_date => Date.today,
                                  :via => 'IM')
        get 'index', { :via => 'phone'}
        expect(assigns(:customer_comm_records)).to match_array([rec1])
      end

      it "should return @customer's comm record for user with right" do
        
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "CustomerCommRecordx::CustomerCommRecord.where(:void => true)")  #none returned if this sql_code is executed
        user_access1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'kustomerx_customers', :role_definition_id => @role.id, :rank => 40)
        session[:employee] = true
        session[:user_id] = @u.id
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id, :comm_category_id => @c_cate.id, :void => false, :comm_date => Date.today)
        get 'index'
        #expect(response).to be_success
        expect(assigns(:customer_comm_records)).to match_array([])
      end

    end
  
    describe "GET 'new'" do
      it "returns http success for users without customer id" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        rec = FactoryGirl.attributes_for(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id)
        get 'new', { :customer_id => @cust.id}
        expect(response).to be_success
      end
      
      it "should http success for users with customer_id" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        rec = FactoryGirl.attributes_for(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id)
        get 'new', { :customer_id => @cust.id}
        expect(response).to be_success
      end

    end
  
    describe "GET 'create'" do
      it "should redirect to new page for user without customer_id when customer name not selected" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        rec = FactoryGirl.attributes_for(:customer_comm_recordx_customer_comm_record, :subject => nil)
        get 'create', { :customer_comm_record => rec, :customer_id => @cust.id}
        expect(response).to render_template("new")
      end
      
      it "should create new record for user without customer id but selecting the customer name" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        rec = FactoryGirl.attributes_for(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id)
        get 'create', { :customer_comm_record => rec, :customer_id => @cust.id }
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should create record for user w/ customer_id" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        rec = FactoryGirl.attributes_for(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id)
        get 'create', { :customer_comm_record => rec, :customer_id => @cust.id}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      end
    end
  
    describe "GET 'edit'" do
      it "returns http success for users with right" do
        user_access1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'kustomerx_customers', :role_definition_id => @role.id, :rank => 1, :sql_code => '')
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id)
        get 'edit', { :id => rec.id, :customer_id => @cust.id}
        expect(response).to be_success
      end
    end
  
    describe "GET 'update'" do
      it "should update for users with right" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "", :masked_attrs => ['=content'])
        session[:employee] = true
        session[:user_id] = @u.id
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id)
        get 'update', { :id => rec.id, :customer_comm_record => {:subject => 'new subject'}}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit for data error" do
        user_access1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'kustomerx_customers', :role_definition_id => @role.id, :rank => 1, :sql_code => '')
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customer_comm_recordx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "", :masked_attrs => ['=content'])
        session[:employee] = true
        session[:user_id] = @u.id
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id)
        get 'update', { :id => rec.id, :customer_comm_record => {:subject => ''}}
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
        rec = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :customer_id => @cust.id, :comm_category_id => @c_cate.id)
        get 'show', { :id => rec.id}
        expect(response).to be_success
      end
    end
  
  end
end
