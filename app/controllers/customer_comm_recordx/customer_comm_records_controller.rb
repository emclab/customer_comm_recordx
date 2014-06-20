require_dependency "customer_comm_recordx/application_controller"

module CustomerCommRecordx
  class CustomerCommRecordsController < ApplicationController
    before_filter :require_employee
    before_filter :load_customer
    
    helper_method :contact_via
    
    def index
      @title= "客户联系记录"
      @customer_comm_records = params[:customer_comm_recordx_customer_comm_records][:model_ar_r]
      @customer_comm_records = @customer_comm_records.where(:customer_id => @customer.id) if @customer
      @customer_comm_records = @customer_comm_records.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('customer_comm_record_index_view', 'customer_comm_recordx')
    end
  
    def new
      @title= "新客户联系记录"
      @customer_comm_record = CustomerCommRecordx::CustomerCommRecord.new() 
      @erb_code = find_config_const('customer_comm_record_new_view', 'customer_comm_recordx')      
    end
  
    def create
      @customer_comm_record = CustomerCommRecordx::CustomerCommRecord.new(params[:customer_comm_record], :as => :role_new)
      @customer_comm_record.last_updated_by_id = session[:user_id]
      @customer_comm_record.reported_by_id = session[:user_id]
      if @customer_comm_record.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @customer = CustomerCommRecordx.customer_class.find_by_id(params[:customer_comm_record][:customer_id]) if params[:customer_comm_record].present? && params[:customer_comm_record][:customer_id].present?
        @erb_code = find_config_const('customer_comm_record_new_view', 'customer_comm_recordx')  
        flash.now[:error] = t('Data Error. Not Saved!')
        render 'new'
      end

    end
  
    def edit
      @customer_comm_record = CustomerCommRecordx::CustomerCommRecord.find_by_id(params[:id])  
      @erb_code = find_config_const('customer_comm_record_edit_view', 'customer_comm_recordx')      
    end
  
    def update
      @customer_comm_record = CustomerCommRecordx::CustomerCommRecord.find_by_id(params[:id])
      @customer_comm_record.last_updated_by_id = session[:user_id]
      if @customer_comm_record.update_attributes(params[:customer_comm_record], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('customer_comm_record_edit_view', 'customer_comm_recordx')
        flash.now[:error] = t('Data Error. Not Updated!')
        render 'edit'
      end
      
    end
  
    def show
      @customer_comm_record = CustomerCommRecordx::CustomerCommRecord.find_by_id(params[:id])
      @erb_code = find_config_const('customer_comm_record_show_view', 'customer_comm_recordx')
    end
    
    protected
    
    def contact_via
      #phone call, meeting, fax, IM, email, letter (writing), online, other
      #[['电话'],['会面'],['传真'],['电邮'],['即时信息IM'],['信件'],['互联网。如网络视频'],['其他']]
      find_config_const('contact_via', 'customer_comm_recordx').split(',').map(&:strip)
    end
    
    def load_customer
      @customer = CustomerCommRecordx.customer_class.find_by_id(params[:customer_id]) if params[:customer_id].present?
      @customer = CustomerCommRecordx.customer_class.find_by_id(CustomerCommRecordx::CustomerCommRecord.find_by_id(params[:id]).customer_id) if params[:id].present?
    end
  end
end
