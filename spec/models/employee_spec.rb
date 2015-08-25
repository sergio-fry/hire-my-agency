require 'rails_helper'

RSpec.describe Employee, type: :model do
  %w( name status salary ).each do |attr|
    it "should not be valid when #{attr} is blank" do
      employee = FactoryGirl.build(:employee, attr => nil)
      employee.valid?
      expect(employee.errors.added?(attr, :blank)).to be_truthy
    end
  end

  describe "#name" do
    it "should be valid when name words count = 3" do
      employee = FactoryGirl.build(:employee, name: "Сергей Олегович Удалов")
      expect(employee).to be_valid
    end

    [
      "Сергей Удалов",
      "Сергей Олегович Удалов Питерский",
      "Сергей Олегович Udalov",
      "Сергей Олегович\tУдалов",
      "Сергей Олегович Удалов\nПитерский",
      "Сергей Олегович Удалов2",
    ].each do |name|
      context "when name = '#{name}'" do
        it "should not be valid" do
          employee = FactoryGirl.build(:employee, name: name)
          expect(employee).to_not be_valid
        end
      end
    end
  end

  describe "#contacts" do
    it "should not be valid when email is present but phone is blank" do
      employee = FactoryGirl.build(:employee, email: "foo@bar.com", phone: nil)
      expect(employee).to be_valid
    end

    it "should not be valid when phone is present but email is blank" do
      employee = FactoryGirl.build(:employee, email: nil, phone: "+7 916 3746238")
      expect(employee).to be_valid
    end

    it "should not be valid when email has wrong format" do
      employee = FactoryGirl.build(:employee, email: "_wrong-email-@domain.com-")
      employee.valid?
      expect(employee.errors.added?(:email)).to be_truthy
    end

    it "should not be valid when phone has wrong format" do
      employee = FactoryGirl.build(:employee, phone: "call me!")
      expect(employee).to_not be_valid
    end

    it "should not be valid when both phone ant email are blank" do
      employee = FactoryGirl.build(:employee, email: nil, phone: nil)
      expect(employee).to_not be_valid
    end
  end

  describe "#skills" do
    let(:employee) { FactoryGirl.create(:employee) }

    it "should be possible to add skill" do
      expect do
        employee.skills << FactoryGirl.create(:skill)
        employee.save
      end.to change(employee.skills, :count).by(1)
    end

    it "should not be valid when no skills defined" do
      employee = FactoryGirl.build(:employee, skills: [])
      employee.valid?
      expect(employee.errors.added?(:skills, :blank)).to be_truthy
    end
  end
end
