require 'rails_helper'

RSpec.describe DailyMetrics::ReviewTurnaroundJob, type: :job do
  describe '.perform' do
    it_behaves_like 'metric job'
  end
end
