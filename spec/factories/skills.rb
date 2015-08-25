FactoryGirl.define do
  sequence :skill_title do |n|
    "Skill ##{n}"
  end

  factory :skill do
    title { generate(:skill_title) }
  end

end
