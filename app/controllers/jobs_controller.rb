class JobsController < ApplicationController
  respond_to :json

  def index
    @jobs = Job.order("salary DESC")
    @jobs = @jobs.with_less_skills_than(params[:skills], 1.0) if params[:skills].present?
    @jobs = @jobs.where(status: params[:status]) if params[:status].present?
    @jobs = @jobs.paginate(page: params[:page], per_page: params[:per_page] || 10)

    respond_with @jobs
  end

  def total
    @jobs = Job.all
    @jobs = @jobs.with_less_skills_than(params[:skills], 1.0) if params[:skills].present?
    @jobs = @jobs.where(status: params[:status]) if params[:status].present?

    respond_with total: @jobs.count
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

  private

  def job_params
    params.require(:job).permit(:title, :salary, :expires_in_days, :contacts, :skills_list)
  end

end
