class SkillsController < ApplicationController
  respond_to :json

  def search
    @skills = Skill.where("title ILIKE ?", "#{params[:query]}%").limit(50)

    respond_with @skills
  end
end
