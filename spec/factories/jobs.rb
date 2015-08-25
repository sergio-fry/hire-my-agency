FactoryGirl.define do
  factory :job do
    title "Great Job"
    expires_in_days 1.5
    salary 1500
    contacts "+7 916253712, email@domain.com"
    created_at { 1.hour.ago }
    skills { [Skill.find_or_create_by(title: "Foo"), Skill.find_or_create_by(title: "Bar")] }
  end
end
