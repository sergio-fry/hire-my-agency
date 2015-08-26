class JobsController < ApplicationController
  respond_to :json

  def index
    @jobs = Job.paginate(page: params[:page], per_page: params[:per_page] || 10)
    respond_with @jobs
  end

  def total
    respond_with total: Job.count
  end

  def show
    @job = Job.find params[:id]
    respond_with @job.as_json(methods: [:skills, :skill_ids])
  end
end
