FactoryGirl.define do
  factory :employee do
    name "Удалов Сергей Олегович"
    phone "+7 928 6263726"
    email "email@domain.com"
    status Employee::STATUS_NEED_JOB
    salary 1000
    skills { [Skill.find_or_create_by(title: "Foo"), Skill.find_or_create_by(title: "Bar")] }
  end
end
