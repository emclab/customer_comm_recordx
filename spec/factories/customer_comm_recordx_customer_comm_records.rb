# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer_comm_recordx_customer_comm_record, :class => 'CustomerCommRecordx::CustomerCommRecord' do
    resource_id 1
    resource_string 'kustomerx/customers'
    via "MyString"
    subject "MyString"
    contact_info "MyText"
    content "MyText"
    last_updated_by_id 1
    comm_category_id 1
    reported_by_id 1
    comm_date "2013-10-13"
    void false
    category "customer"
  end
end
