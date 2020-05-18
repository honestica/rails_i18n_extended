ActiveRecord::Schema.define do
  self.verbose = false

  create_table :models, :force => true do |t|
    t.string :test_attribute
    t.string :test_enum_attribute
  end

end