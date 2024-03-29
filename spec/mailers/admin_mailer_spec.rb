require 'rails_helper'

describe AdminMailer, type: :mailer do
  describe '#notify_below_rate' do
    let(:emails) { ['mail1@example.com', 'mail2@example.com'] }
    let(:alert) { create(:alert, :with_repository, emails: emails) }
    let(:mail) { AdminMailer.notify_below_rate(alert) }

    before do
      stub_env('SENDGRID_USERNAME', 'metrics@example.com')
    end

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('mailer.notify_below_rate.subject'))
    end

    it 'renders the receiver email' do
      emails = alert.emails
      expect(mail.to).to eq(emails)
    end

    it 'renders the sender email' do
      expect(mail.from).to eq([ENV['SENDGRID_USERNAME']])
    end

    it 'renders the metric name' do
      expect(mail.body).to include(I18n.t('mailer.notify_below_rate.body.metric',
                                          metric: alert.metric_name))
    end

    it 'renders the threshold' do
      expect(mail.body).to include(I18n.t('mailer.notify_below_rate.body.threshold',
                                          threshold: alert.threshold))
    end

    context 'when entity is a repository' do
      let!(:repository) { create(:repository) }
      let(:alert) { build(:alert, repository: repository) }

      it 'renders the repository name' do
        expect(mail.body).to include(I18n.t('mailer.notify_below_rate.body.repository',
                                            repository: repository.name))
      end
    end

    context 'when entity is a department' do
      let(:department) { Department.find_by(name: 'backend') }
      let(:alert) { create(:alert, :with_department, department: department) }
      let(:mail) { AdminMailer.notify_below_rate(alert) }

      it 'renders the department name' do
        expect(mail.body).to include(I18n.t('mailer.notify_below_rate.body.department',
                                            department: department.name))
      end
    end
  end
end
