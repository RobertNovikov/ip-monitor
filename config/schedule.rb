# frozen_string_literal: true

set :output, './log/cron_log.log'
set :job_template, "/bin/sh -l -c ':job'"

every 1.minute do
  rake 'check_availability'
end
