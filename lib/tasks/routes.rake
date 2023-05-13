# frozen_string_literal: true

desc 'Shows existing routes'
task routes: :environment do
  ::BaseApi.routes.each do |route|
    method = route.request_method.ljust(10)
    path = route.origin
    puts "#{method} #{path}"
  end
end
