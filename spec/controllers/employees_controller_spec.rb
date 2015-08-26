require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  describe "#index" do
    before do
      @employee = FactoryGirl.create(:employee)
    end

    it "should return employee" do
      get :index, format: :json
      expect(assigns(:employees)).to include(@employee)
    end
  end

end
