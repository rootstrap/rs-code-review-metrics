require 'rails_helper'

describe ProjectsImporterJob do
  describe '#perform' do
    it 'correctly initializes the ProjectsImporter processor and calls it' do
      expect_any_instance_of(Processors::ProjectsImporter)
        .to receive(:call)
        .once

      described_class.perform_now
    end
  end
end
