require 'rails_helper'

describe Builders::Chartkick::GenerateChartImage do
  let(:url) { Faker::Internet.url }
  let(:product) { create(:product) }
  let(:label_name) { product.name }

  shared_examples_for 'url_image_generation' do
    context 'when request payload is correct' do
      before { stub_url_generation(payload, url) }

      it 'returns a correct url' do
        expect(subject).to eq(url)
      end
    end

    context 'when request payload is not correct' do
      before { stub_failed_url_generation(payload) }

      it 'notifies the error to exception hunter' do
        expect(subject).to be_nil
      end
    end

    context 'when request is not successful' do
      before { stub_exception_url_generation(payload) }

      it 'notifies the error to exception hunter' do
        expect(ExceptionHunter).to receive(:track).with(Faraday::ServerError)

        subject
      end
    end
  end

  context '.generate_url' do
    let(:defect_escape_rate) do
      {
        per_defect_escape_rate:
          [
            data: {
              '2021-07-26': 50,
              '2021-08-02': 40
            }
          ]
      }
    end

    let(:data) { defect_escape_rate[:per_defect_escape_rate].first[:data] }

    let(:payload) do
      {
        "backgroundColor": '#fff',
        "width": 500,
        "height": 300,
        "devicePixelRatio": 1.0,
        "chart": {
          "type": 'bar',
          "options": {
            "plugins": {
              "tickFormat": {
                "suffix": '%'
              }
            }
          },
          "data": {
            "labels": data.keys,
            "datasets": [
              {
                "label": product.name,
                "fill": false,
                "lineTension": 0.4,
                "data": data.values
              }
            ]
          }
        }
      }
    end

    subject { described_class.send(:new, label_name, data, '%', 'bar').generate_url }

    it_behaves_like 'url_image_generation'
  end

  context '.generate_url_mutiple_bar' do
    let(:jira_sprint1) { create(:jira_sprint) }
    let(:jira_sprint2) { create(:jira_sprint) }

    let(:data) do
      [
        {
          name: 'Commitment',
          data: {
            jira_sprint1.name => jira_sprint1.points_committed,
            jira_sprint2.name => jira_sprint2.points_committed
          }
        },
        {
          name: 'Completed',
          data: {
            jira_sprint1.name => jira_sprint1.points_completed,
            jira_sprint2.name => jira_sprint2.points_completed
          }
        }
      ]
    end

    let(:payload) do
      {
        "backgroundColor": '#fff',
        "width": 500,
        "height": 300,
        "chart": {
          "type": 'bar',
          "options": {
            "plugins": {
              "tickFormat": {
                "suffix": '%'
              }
            }
          },
          "data": {
            "labels": data.first[:data].keys,
            "datasets": [
              {
                "label": data.first[:name],
                "data": data.first[:data].values
              },
              {
                "label": data.second[:name],
                "data": data.second[:data].values
              }
            ]
          }
        }
      }
    end

    subject { described_class.send(:new, label_name, data, '%', 'bar').generate_url_mutiple_bar }

    it_behaves_like 'url_image_generation'
  end
end
