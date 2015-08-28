class JobsController < ApplicationController
  respond_to :json

  def index
    @jobs = jobs_scope.order("salary DESC")
    @jobs = @jobs.paginate(page: params[:page], per_page: params[:per_page] || 10)

    respond_with @jobs
  end

  def total
    respond_with total: jobs_scope.count
  end

  def show
    @job = Job.find params[:id]
    respond_with @job.as_json(methods: [:skills, :skills_list])
  end

  def update
    @job = Job.find params[:id]
    @job.update_attributes job_params

    respond_with @job
  end

  def create
    @job = Job.new job_params
    @job.save

    respond_with @job
  end

  private

  def jobs_scope
    match_level = (params[:match] || 1.0).to_f.abs
    match_level = [0.25, match_level].max

    jobs = Job.all
    jobs = jobs.with_less_skills_than(params[:skills], match_level) if params[:skills].present?
    jobs = jobs.active if params[:active].present?
    jobs = jobs.where("salary >= ?", params[:salary].to_f * match_level) if params[:salary].present?

    jobs
  end

  def job_params
    params.require(:job).permit(:title, :salary, :expires_in_days, :contacts, :skills_list)
  end

end
