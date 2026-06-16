require 'rails_helper'

RSpec.describe AdminUsers::SessionsController, :unauthenticated, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:admin_user] }

  describe 'GET #new' do
    it 'is reachable without authentication so logged-out users can sign in' do
      get :new

      expect(response).to have_http_status(:ok)
    end
  end
end
