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

  describe "skills" do
    before do
      @skill_1 = FactoryGirl.create(:skill) 
      @skill_2 = FactoryGirl.create(:skill) 
      @skill_3 = FactoryGirl.create(:skill) 
    end

    describe "#with_skills" do
      before do
        @job_1 = FactoryGirl.create(:job, skills: [@skill_1])
        @job_2 = FactoryGirl.create(:job, skills: [@skill_2])
        @job_3 = FactoryGirl.create(:job, skills: [@skill_1, @skill_2])
      end

      {
        [@skill_1] => [@job_1, @job_3],
        [@skill_2] => [@job_2, @job_3],
        [@skill_1, @skill_2] => [@job_3],
        [@skill_3] => [],
      }

      it "should return job_1, job_3 when searching skill_1" do
        expect(Job.with_skills([@skill_1], 1).to_a.sort).to eq([@job_1, @job_3].sort)
      end

      it "should return job_2, job_3 when searching skill_2" do
        expect(Job.with_skills([@skill_2], 1).to_a.sort).to eq([@job_2, @job_3].sort)
      end

      it "should return job_3 when searching skill_1 and skill_2" do
        expect(Job.with_skills([@skill_1, @skill_2], 1).to_a.sort).to eq([@job_3].sort)
      end

      it "should return nothing when searching skill_3" do
        expect(Job.with_skills([@skill_3], 1).to_a.sort).to be_blank
      end
    end

    describe "#skills_list" do
      before do
        @job = FactoryGirl.create(:job, skills: [@skill_1, @skill_2])
      end

      it "should be commaseparated list of skills" do
        expect(@job.skills_list).to eq("#{@skill_1.title}, #{@skill_2.title}")
      end

      it "should accept new skills" do
        @job.skills_list = "#{@skill_1.title}, #{@skill_2.title}, , #{@skill_3.title}"
        expect(@job.skills).to include(@skill_3)
      end

      it "should remove missing skills" do
        @job.skills_list = "#{@skill_1.title}"
        expect(@job.skills).to_not include(@skill_2)
      end
    end
  end
end
