require 'rails_helper'
require 'rake'

RSpec.describe 'running the rake task metrics:remove_blog_post_count' do
  before do
    load_rake_metrics
  end

  let(:load_rake_metrics) do
    Rake.application.rake_require 'tasks/metrics'
    Rake::Task.define_task(:environment)
  end

  let(:rake_remove_blog_post_count_metrics) do
    Rake.application.invoke_task 'metrics:remove_blog_post_count'
  end

  it 'calls the BlogPostCountMetricsRemover processor' do
    expect(Processors::BlogPostCountMetricsRemover).to receive(:call)

    rake_remove_blog_post_count_metrics
  end
end
