FactoryGirl.define do
  factory :post_one, class: Post do
    id 1
    title 'MyString1'
    content 'MyText'
    user_id 1
    main false
    featured false
    position 1
    visits 0
    photo_file_name { 'missing.png' }
    photo_content_type { 'image/png' }
    photo_file_size { 1024 }
    # photo_updated_at '2015-05-04 19:50:44'
  end

  factory :post_two, class: Post do
    id 2
    title 'MyString2'
    content 'MyText'
    user_id 1
    main false
    featured 0
    position 2
    visits 0
    photo_file_name { 'missing.png' }
    photo_content_type { 'image/png' }
    photo_file_size { 1024 }
  end

  factory :post_three, class: Post do
    id 3
    title 'MyString3'
    content 'MyText'
    user_id 1
    main true
    featured 0
    position 3
    visits 0
    photo_file_name { 'missing.png' }
    photo_content_type { 'image/png' }
    photo_file_size { 1024 }
  end

  factory :post_four, class: Post do
    id 4
    title 'MyString4'
    content 'MyText'
    user_id 5
    main true
    featured true
    position 4
    visits 0
    photo_file_name { 'missing.png' }
    photo_content_type { 'image/png' }
    photo_file_size { 1024 }
  end

  factory :post_five, class: Post do
    id 5
    title 'MyString5'
    content 'MyText'
    user_id 1
    main false
    featured 0
    position 5
    visits 0
    photo_file_name { 'missing.png' }
    photo_content_type { 'image/png' }
    photo_file_size { 1024 }
  end

  factory :post_six, class: Post do
    id 6
    title 'MyString6'
    content 'MyText'
    user_id 1
    main true
    featured 0
    position 6
    visits 0
    photo_file_name { 'missing.png' }
    photo_content_type { 'image/png' }
    photo_file_size { 1024 }
  end
end