require 'rails_helper'

##
# Helper to validate a custom ActiveModel::Validator.
# A custom ActiveModel::Validator interfaces adds errors to the given
# validation_target.errors collection.
#
# This method creates a configurable object to validate it with an
# ActiveModel::Validator that also complies with ActiveModel::Validations.
# It receives an optional target_configuration_block that can be used
# to configure the messages on the validation_target, for example
#
#   let(:empty_list) do
#     validation_target 'list' do |list|
#       allow(list).to receive(:length).and_return(0)
#     end
#   end
def validation_target(double_name, &target_configuration_block)
  double(double_name).tap do |validation_target|
    validation_target.extend ActiveModel::Validations
    allow(validation_target).tap do |allow_target|
      allow_target.to receive(:validation_context=)
      allow_target.to receive(:validation_context)
      allow_target.to receive(:_run_validate_callbacks)
    end
    target_configuration_block&.call(validation_target)
  end
end
