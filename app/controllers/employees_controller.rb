class EmployeesController < ApplicationController
  respond_to :json

  def index
    @employees = Employee.order(:salary)

    @employees = @employees.with_skills(params[:skills], 1.0) if params[:skills].present?

    @employees = @employees.where(status: params[:status]) if params[:status].present?


    @employees = @employees.paginate(page: params[:page], per_page: params[:per_page] || 10)

    respond_with @employees
  end

  def total
    @employees = Employee.all
    @employees = @employees.with_skills(params[:skills], 1.0) if params[:skills].present?
    @employees = @employees.where(status: params[:status]) if params[:status].present?

    respond_with total: @employees.count
  end

  def show
    @employee = Employee.find params[:id]
    respond_with @employee.as_json(methods: :skills)
  end
end
