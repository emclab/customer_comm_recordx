class CreateCustomerCommRecordxCustomerCommRecords < ActiveRecord::Migration
  def change
    create_table :customer_comm_recordx_customer_comm_records do |t|
      t.integer :customer_id
      t.string :via
      t.string :subject
      t.text :contact_info
      t.text :content
      t.integer :last_updated_by_id
      t.integer :comm_category_id
      t.integer :reported_by_id
      t.date :comm_date
      t.boolean :void, :default => false
      t.integer :followup_to_id
      t.timestamps
      t.string :fort_token
      
    end
    
    add_index :customer_comm_recordx_customer_comm_records, :customer_id, :name => :record_customer_id
    add_index :customer_comm_recordx_customer_comm_records, :subject
    add_index :customer_comm_recordx_customer_comm_records, :comm_date
    add_index :customer_comm_recordx_customer_comm_records, :via
    add_index :customer_comm_recordx_customer_comm_records, :void
    add_index :customer_comm_recordx_customer_comm_records, :reported_by_id, :name => :record_reported_by_id
    add_index :customer_comm_recordx_customer_comm_records, :comm_category_id, :name => :record_category_id
    add_index :customer_comm_recordx_customer_comm_records, :followup_to_id, :name => :record_followup_to_id
    add_index :customer_comm_recordx_customer_comm_records, :fort_token, :name => :record_token
  end
end
