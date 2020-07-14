require 'rails_helper'

RSpec.describe CodeClimate::DepartmentsController, type: :request do
  fixtures :departments, :languages

  let(:ruby_lang) { Language.find_by(name: 'ruby') }
  let(:project) { create(:project, name: 'rs-metrics', language: ruby_lang) }
  let(:department) { project.language.department }

  describe '#show' do
    context 'with a valid department id' do
      it 'returns status ok' do
        get "/development_metrics/code_climate/departments/#{department.name}",
            params: { metric: { period: 4 }, lang: ruby_lang }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with a valid metric-period given' do
      it 'returns status ok' do
        get "/development_metrics/code_climate/departments/#{department.name}",
            params: { metric: { period: 4 }, lang: ruby_lang }

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
