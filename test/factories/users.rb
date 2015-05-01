FactoryGirl.define do
  factory :one, class: User do
    username 'nickname1'
    email '1example@test.com'
    password '1234567890'
    rank 4
  end

  factory :admin, class: User do
    username 'nickname2'
    email '2example@test.com'
    password '1234567890'
    rank 4
  end

  factory :editor, class: User do
    username 'nickname3'
    email '3example@test.com'
    password '1234567890'
    rank 3
  end

  factory :author, class: User do
    id 5
    username 'nickname4'
    email '4example@test.com'
    password '1234567890'
    rank 2
  end

  factory :corrector, class: User do
    username 'nickname5'
    email '5example@test.com'
    password '1234567890'
    rank 1
  end

  factory :newbie, class: User do
    username 'nickname6'
    email '6example@test.com'
    password '1234567890'
    rank 0
  end

  factory :two, class: User do
    username 'nickname7'
    email '7example@test.com'
    password '1234567890'
    rank 0
  end
end