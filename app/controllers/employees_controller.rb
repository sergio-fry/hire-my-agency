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
    respond_with @employee.as_json(methods: [:skills, :skills_list, :contacts])
  end

  def update
    @employee = Employee.find params[:id]
    @employee.update_attributes employee_params

    respond_with @employee
  end

  def create
    @employee = Employee.new employee_params
    @employee.save

    respond_with @employee
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :salary, :phone, :email, :status, :skills_list)
  end
end
