class CreateCustomerCommRecordxCustomerCommRecords < ActiveRecord::Migration
  def change
    create_table :customer_comm_recordx_customer_comm_records do |t|
      t.integer :resource_id
      t.string :via
      t.string :subject
      t.text :contact_info
      t.text :content
      t.integer :last_updated_by_id
      t.integer :comm_category_id
      t.integer :reported_by_id
      t.date :comm_date
      t.boolean :void, :default => false
      t.timestamps
      t.string :category
      t.string :resource_string
      
    end
    
    add_index :customer_comm_recordx_customer_comm_records, :resource_id, :name => :comm_record_resource_id
    add_index :customer_comm_recordx_customer_comm_records, :subject
    add_index :customer_comm_recordx_customer_comm_records, :comm_date
    add_index :customer_comm_recordx_customer_comm_records, :reported_by_id, :name => :comm_record_reported_by_id
    add_index :customer_comm_recordx_customer_comm_records, :category
    add_index :customer_comm_recordx_customer_comm_records, :resource_string, :name => :comm_record_resource_string
  end
end
