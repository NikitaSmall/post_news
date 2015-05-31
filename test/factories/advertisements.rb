FactoryGirl.define do
  factory :advertisement do
    title "MyString"
    content "MyString"
    enabled false
    link "google.com"
    visits 0
    photo_file_name { 'missing.png' }
    photo_content_type { 'image/png' }
    photo_file_size { 1024 }
  end

end
