# frozen_string_literal: true

desc 'Create CheckAvailabilityJob'
task check_availability: :environment do
  CheckAvailabilityJob.perform_async
end
