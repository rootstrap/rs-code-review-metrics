require 'rails_helper'

describe MetaTagsHelper, type: :helper do
  let(:product) { create(:product) }
  let(:repository) { create(:repository) }
  let(:ruby) { Language.find_or_create_by(name: 'ruby') }
  let(:department) { ruby.department }
  let(:default_text) { 'Engineering Metrics' }

  describe '.meta_title' do
    context 'when request to products_development_metrics_path' do
      before do
        allow(helper).to receive(:current_page?)
          .with(products_development_metrics_path).and_return(true)
      end

      context 'when no product has been selected' do
        it 'returns the correct title' do
          expect(helper.meta_title).to eq(default_text)
        end
      end

      context 'when product has been selected' do
        it 'returns the correct title' do
          assign(:product, product)
          expect(helper.meta_title).to eq(product.name + ' summary')
        end
      end
    end

    context 'when request to products_metrics_development_metrics_path' do
      let!(:metric_definition) { create(:metric_definition, code: :defect_escape_rate) }

      before do
        allow(helper).to receive(:current_page?)
          .with(products_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(products_metrics_development_metrics_path).and_return(true)
      end

      it 'returns the correct title' do
        assign(:query_metric_name, :defect_escape_rate)
        assign(:product, product)
        expect(helper.meta_title).to eq(product.name + ' - ' + metric_definition.name)
      end
    end

    context 'when request to repositories_development_metrics_path' do
      before do
        allow(helper).to receive(:current_page?)
          .with(products_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(products_metrics_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(repositories_development_metrics_path).and_return(true)
      end

      it 'returns the correct title' do
        assign(:repository, repository)
        expect(helper.meta_title).to eq(repository.name + ' summary')
      end
    end

    context 'when request to open_source_index_path' do
      before do
        allow(helper).to receive(:current_page?)
          .with(products_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(products_metrics_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(repositories_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(open_source_index_path).and_return(true)
      end

      it 'returns the correct title' do
        expect(helper.meta_title).to eq('Open Source repositories')
      end
    end

    context 'when request to departments_development_metrics_path' do
      before do
        allow(helper).to receive(:current_page?)
          .with(products_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(products_metrics_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(repositories_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(open_source_index_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(departments_development_metrics_path).and_return(true)
      end

      context 'when no department has been selected' do
        it 'returns the correct title' do
          expect(helper.meta_title).to eq('Departments')
        end
      end

      context 'when department has been selected' do
        it 'returns the correct title' do
          assign(:department, department)
          expect(helper.meta_title).to eq(department.name + ' department metrics')
        end
      end
    end

    context 'when request to tech_blog_path' do
      before do
        allow(helper).to receive(:current_page?)
          .with(products_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(products_metrics_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(repositories_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(open_source_index_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(departments_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(tech_blog_path).and_return(true)
      end

      it 'returns the correct title' do
        expect(helper.meta_title).to eq('Tech Blog visits')
      end
    end
  end

  describe '.meta_description' do
    let(:repository_count) { 5 }
    let!(:repositories) { create_list(:repository, repository_count, :open_source) }

    let!(:metric_definition) { create(:metric_definition, code: :defect_escape_rate) }

    let(:rate) do
      {
        per_defect_escape_values:
          [
            data: {
              rate: 66
            }
          ]
      }
    end

    context 'when request to products_development_metrics_path' do
      before do
        allow(helper).to receive(:current_page?)
          .with(products_development_metrics_path).and_return(true)
      end

      context 'when no product has been selected' do
        it 'returns the correct description' do
          expect(helper.meta_description).to eq(default_text)
        end
      end

      context 'when product has been selected' do
        let(:expected_description) { 'Summary - Overall ' + metric_definition.name + ': 66% -' }

        it 'returns the correct description' do
          assign(:product, product)
          assign(:show_defect_escape_rate, true)
          assign(:defect_escape_rate_definition, metric_definition)
          assign(:defect_escape_rate, rate)

          expect(helper.meta_description).to eq(expected_description)
        end
      end
    end

    context 'when request to products_metrics_development_metrics_path' do
      let(:expected_description) { 'Overall ' + metric_definition.name + ': 66%' }

      before do
        allow(helper).to receive(:current_page?)
          .with(products_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(products_metrics_development_metrics_path).and_return(true)
      end

      it 'returns the correct title' do
        assign(:product, product)
        assign(:show_defect_escape_rate, true)
        assign(:defect_escape_rate_definition, metric_definition)
        assign(:defect_escape_rate, rate)

        expect(helper.meta_description).to eq(expected_description)
      end
    end

    context 'when request to repositories_development_metrics_path' do
      before do
        allow(helper).to receive(:current_page?)
          .with(products_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(products_metrics_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(repositories_development_metrics_path).and_return(true)
      end

      it 'returns the correct description' do
        assign(:repository, repository)
        expect(helper.meta_description).to eq(repository.name + ' summary')
      end
    end

    context 'when request to open_source_index_path' do
      before do
        allow(helper).to receive(:current_page?)
          .with(products_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(products_metrics_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(repositories_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(open_source_index_path).and_return(true)
      end

      it 'returns the correct description' do
        assign(:total_repositories, repository_count)
        expect(helper.meta_description).to eq("#{repository_count} open source repositories")
      end
    end

    context 'when request to departments_development_metrics_path' do
      before do
        allow(helper).to receive(:current_page?)
          .with(products_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(products_metrics_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(repositories_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(open_source_index_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(departments_development_metrics_path).and_return(true)
      end

      context 'when no department has been selected' do
        it 'returns the correct description' do
          expect(helper.meta_title).to eq('Departments')
        end
      end

      context 'when department has been selected' do
        it 'returns the correct description' do
          assign(:department, department)
          expect(helper.meta_description).to eq(department.name + ' department metrics')
        end
      end
    end

    context 'when request to tech_blog_path' do
      let(:technology) { create(:technology) }

      let(:this_month_metric) do
        create(
          :metric,
          ownable: technology,
          interval: Metric.intervals[:monthly],
          name: Metric.names[:blog_visits],
          value: 5,
          value_timestamp: Time.zone.now.end_of_month
        )
      end

      before do
        allow(helper).to receive(:current_page?)
          .with(products_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(products_metrics_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(repositories_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(open_source_index_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(departments_development_metrics_path).and_return(false)

        allow(helper).to receive(:current_page?)
          .with(tech_blog_path).and_return(true)
      end

      it 'returns the correct description' do
        assign(:month_to_date_visits, 5)
        expect(helper.meta_description).to eq('5 visits this month')
      end
    end
  end
end
