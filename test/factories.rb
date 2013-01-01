FactoryGirl.define do
  
  factory :post do
    title { Faker::Lorem.sentence.chomp('.') } 
    body { Faker::Lorem.paragraphs.join("\r\n") }
    state 'draft'
    factory :finalized_post do
      state 'finalized'
    end
    factory :published_post do
      state 'published'
      published_at { Time.zone.now }
    end
    factory 'tossed_post' do
      state 'tossed'
    end
  end
  
  factory :editor do
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
  end
  
end