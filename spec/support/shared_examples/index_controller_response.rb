require 'rails_helper'

RSpec.shared_examples 'controller index response' do
  it 'returns status ok' do
    expect(response).to have_http_status(:ok)
  end

  it 'renders the index view' do
    expect(response).to render_template(:index)
  end
end
