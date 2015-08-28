class EmployeesController < ApplicationController
  respond_to :json

  def index
    @employees = employees_scope.order(:salary).includes(:skills)
    @employees = @employees.paginate(page: params[:page], per_page: params[:per_page] || 10)

    respond_with @employees.as_json(methods: :skills)
  end

  def total
    respond_with total: employees_scope.count
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

  def employees_scope
    match_level = (params[:match] || 1.0).to_f.abs
    match_level = [0.25, match_level].max

    employees = Employee.all
    
    employees = employees.with_skills(params[:skills], match_level) if params[:skills].present?
    employees = employees.where(status: params[:status]) if params[:status].present?
    employees = employees.where("salary <= ?", params[:salary].to_f / match_level) if params[:salary].present?

    employees
  end

  def employee_params
    params.require(:employee).permit(:name, :salary, :phone, :email, :status, :skills_list)
  end
end
