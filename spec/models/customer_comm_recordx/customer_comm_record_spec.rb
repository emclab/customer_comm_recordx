require 'rails_helper'

module CustomerCommRecordx
  RSpec.describe CustomerCommRecord, type: :model do
    it "should be OK" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record)
      expect(r).to be_valid
    end
    
    it "should reject nil subject" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :subject => nil)
      expect(r).not_to be_valid
    end
    
    it "should reject nil contact info" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :contact_info => nil)
      expect(r).not_to be_valid
    end
    
    it "should reject nil content" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :content => nil)
      expect(r).not_to be_valid
    end
    
    it "should reject nil customer_id" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :customer_id => nil)
      expect(r).not_to be_valid
    end

    it "should reject 0 reported_by_id" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :reported_by_id => 0)
      expect(r).not_to be_valid
    end
    
    it "shold reject dup content for the same customer" do
      r = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :content => 'this is a test')
      r1 = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :content => 'This Is A Test')
      expect(r1).not_to be_valid
    end
    
    it "shold be OK with dup content for different customer" do
      r = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :content => 'this is a test')
      r1 = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :content => 'This Is A Test', :customer_id => r.customer_id + 1)
      expect(r1).to be_valid
    end
    
    it "should reject 0 comm category id" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :comm_category_id => 0)
      expect(r).not_to be_valid
    end
    
    it "should reject nil comm category id" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :comm_category_id => nil)
      expect(r).to be_valid
    end
    
    it "should reject nil comm date" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :comm_date => nil)
      expect(r).not_to be_valid
    end
    
    it "should reject 0 customer_id" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :customer_id => 0)
      expect(r).not_to be_valid
    end
  end
end
