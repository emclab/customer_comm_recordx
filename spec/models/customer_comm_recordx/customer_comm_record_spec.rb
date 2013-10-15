require 'spec_helper'

module CustomerCommRecordx
  describe CustomerCommRecord do
    it "should be OK" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record)
      r.should be_valid
    end
    
    it "should reject nil subject" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :subject => nil)
      r.should_not be_valid
    end
    
    it "should reject nil contact info" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :contact_info => nil)
      r.should_not be_valid
    end
    
    it "should reject nil content" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :content => nil)
      r.should_not be_valid
    end
    
    it "should reject nil reported_by_id" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :reported_by_id => nil)
      r.should_not be_valid
    end
    
    it "shold reject dup content" do
      r = FactoryGirl.create(:customer_comm_recordx_customer_comm_record, :content => 'this is a test')
      r1 = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :content => 'This Is A Test')
      r1.should_not be_valid
    end
    
    it "should reject nil comm category id" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :comm_category_id => nil)
      r.should_not be_valid
    end
    
    it "should reject nil comm date" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :comm_date => nil)
      r.should_not be_valid
    end
    
    it "should reject nil customer_id" do
      r = FactoryGirl.build(:customer_comm_recordx_customer_comm_record, :customer_id => nil)
      r.should_not be_valid
    end
  end
end
