require 'rails_helper'

describe RepositoriesImporterJob do
  describe '#perform' do
    it 'correctly initializes the RepositoriesImporter processor and calls it' do
      expect_any_instance_of(Processors::RepositoriesImporter)
        .to receive(:call)
        .once

      described_class.perform_now
    end
  end
end
