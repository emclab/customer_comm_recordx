# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :kustomerx_contact, :class => 'Kustomerx::Contact' do
    customer_id 1
    name "MyString"
    position "MyString3"
    phone "MyString4"
    cell_phone "MyString5"
    email "email@b.com"
    brief_note "MyText8"
  end
end
