# frozen_string_literal: true

FactoryBot.define do
  factory :ip, class: 'Ip' do
    ip { '1.2.3.4' }
    is_sync_enabled { true }
  end
end
