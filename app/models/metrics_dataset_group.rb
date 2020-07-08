class MetricsDatasetGroup
  def initialize(datasets, totals)
    @datasets = datasets
    @totals = totals
  end

  attr_reader :datasets, :totals

  def all_datasets
    datasets + [totals]
  end

  def totals_for(date)
    totals[:data][key_for(date)]
  end

  private

  def key_for(date)
    date.strftime('%B %Y')
  end
end
