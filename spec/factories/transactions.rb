# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    user nil
    value "9.99"
    ident "MyString"
    related_id 1
    related_type "MyString"
  end
end
