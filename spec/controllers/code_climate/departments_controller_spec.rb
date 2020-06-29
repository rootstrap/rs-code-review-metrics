require 'rails_helper'

RSpec.describe CodeClimate::DepartmentsController, type: :controller do
  fixtures :departments, :languages

  let(:ruby_lang) { Language.find_by(name: 'ruby') }
  let(:project) { create(:project, name: 'rs-metrics', language: ruby_lang) }
  let(:department) { project.language.department }

  describe '#show' do
    context 'with a valid department id' do
      it 'returns status ok' do
        get :show, params: { id: department.id }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with an invalid department id' do
      it 'returns status 404' do
        get :show, params: { id: 0 }

        expect(response).to have_http_status(404)
      end
    end

    context 'with a valid metric-period given' do
      it 'returns status ok' do
        get :show, params: { id: department.id, 'metric-period': 'daily' }

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
