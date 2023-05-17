# frozen_string_literal: true

FactoryBot.define do
  factory :availability_report, class: 'AvailabilityReport' do
    rtt { 5 }
  end
end
