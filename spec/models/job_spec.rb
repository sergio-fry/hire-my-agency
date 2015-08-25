require 'rails_helper'

RSpec.describe Job, type: :model do
  %w( title created_at expires_in_days salary contacts ).each do |attr|
    it "should not be valid when #{attr} is blank" do
      job = FactoryGirl.build(:job, attr => nil)
      job.valid?
      expect(job.errors.added?(attr, :blank)).to be_truthy
    end
  end

  it "should not be valid when no skills defined" do
    job = FactoryGirl.build(:job, skills: [])
    job.valid?
    expect(job.errors.added?(:skills, :blank)).to be_truthy
  end
end
