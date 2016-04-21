# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer_comm_recordx_customer_comm_record, :class => 'CustomerCommRecordx::CustomerCommRecord' do
    customer_id 1
    via "MyString"
    subject "MyString"
    contact_info "MyText"
    content "MyText"
    last_updated_by_id 1
    comm_category_id 1
    reported_by_id 1
    comm_date Date.today
    void false
    fort_token '123456789'
  end
end
