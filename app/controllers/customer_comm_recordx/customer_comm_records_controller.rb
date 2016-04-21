require_dependency "customer_comm_recordx/application_controller"

module CustomerCommRecordx
  class CustomerCommRecordsController < ApplicationController
    before_action :require_employee
    before_action :load_record
    
    helper_method :contact_via, :return_users
    
    def index
      @title= t("Communication Records")
      @customer_comm_records = params[:customer_comm_recordx_customer_comm_records][:model_ar_r]
      @customer_comm_records = @customer_comm_records.where('customer_comm_recordx_customer_comm_records.customer_id = ?', @customer.id) if @customer 
      @customer_comm_records = @customer_comm_records.where('customer_comm_recordx_customer_comm_records.comm_category_id = ?', @comm_category_id) if @comm_category_id
      @customer_comm_records = @customer_comm_records.where('customer_comm_recordx_customer_comm_records.via = ?', @via) if @via 
      @customer_comm_records = @customer_comm_records.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('customer_comm_record_index_view', session[:fort_token], 'customer_comm_recordx')
    end
  
    def new
      @title = t("New Communication Record")
      @customer_comm_record = CustomerCommRecordx::CustomerCommRecord.new() 
      @erb_code = find_config_const('customer_comm_record_new_view', session[:fort_token], 'customer_comm_recordx')      
    end
  
    def create
      @customer_comm_record = CustomerCommRecordx::CustomerCommRecord.new(new_params)
      @customer_comm_record.last_updated_by_id = session[:user_id]
      @customer_comm_record.reported_by_id = session[:user_id]
      @customer_comm_record.fort_token = session[:fort_token]
      if @customer_comm_record.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      else
        @erb_code = find_config_const('customer_comm_record_new_view', session[:fort_token], 'customer_comm_recordx')  
        flash.now[:error] = t('Data Error. Not Saved!')
        render 'new'
      end

    end
  
    def edit
      @title = t("Update Communication Record")
      @customer_comm_record = CustomerCommRecordx::CustomerCommRecord.find_by_id(params[:id])  
      @erb_code = find_config_const('customer_comm_record_edit_view', session[:fort_token], 'customer_comm_recordx')      
    end
  
    def update
      @customer_comm_record = CustomerCommRecordx::CustomerCommRecord.find_by_id(params[:id])
      @customer_comm_record.last_updated_by_id = session[:user_id]
      if @customer_comm_record.update_attributes(edit_params)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('customer_comm_record_edit_view', session[:fort_token], 'customer_comm_recordx')
        flash.now[:error] = t('Data Error. Not Updated!')
        render 'edit'
      end
      
    end
  
    def show
      @title = t('Communication Record Info')
      @customer_comm_record = CustomerCommRecordx::CustomerCommRecord.find_by_id(params[:id])
      @erb_code = find_config_const('customer_comm_record_show_view', session[:fort_token], 'customer_comm_recordx')
    end
    
    protected
    
    def contact_via
      #phone call, meeting, fax, IM, email, letter (writing), online, other
      #[['电话'],['会面'],['传真'],['电邮'],['即时信息IM'],['信件'],['互联网。如网络视频'],['其他']]
      find_config_const('contact_via', session[:fort_token], 'customer_comm_recordx').split(',').map(&:strip)
    end
    
    def load_record
      @customer = CustomerCommRecordx.customer_class.find_by_id(params[:customer_id]) if params[:customer_id].present?
      @customer = CustomerCommRecordx.customer_class.find_by_id(params[:customer_comm_record][:customer_id]) if params[:customer_comm_record] && params[:customer_comm_record][:customer_id].present?
      @comm_category_id = params[:comm_category_id] if params[:comm_category_id].present?
      @via = params[:via] if params[:via].present?
      pr = CustomerCommRecordx::CustomerCommRecord.find_by_id(params[:id]) if params[:id].present?
      @customer = CustomerCommRecordx.customer_class.find_by_id(pr.customer_id) if pr.present?
      @comm_category_id = pr.comm_category_id if pr.present?
      @via = pr.via if pr
    end
    
    private
    
    def new_params
      params.require(:customer_comm_record).permit(:comm_category_id, :comm_date, :contact_info, :content, :customer_id, :reported_by_id, 
                    :subject, :via, :void, :followup_to_id)
    end
    
    def edit_params
      params.require(:customer_comm_record).permit(:comm_category_id, :comm_date, :contact_info, :content, :reported_by_id, 
                    :subject, :via, :void, :customer_id, :followup_to_id)
    end

  end
end
