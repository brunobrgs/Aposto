# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :challenge do
    question "MyString"
    private false
    bet_value "9.99"
    min_bets 1
    max_bets 1
    end_date "2012-07-14 23:40:48"
    user_id 1
  end
end
