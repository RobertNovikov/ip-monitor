# frozen_string_literal: true

# Application entry point
class App
  def self.instance
    @instance ||= Rack::Builder.new do
      run App.new
    end.to_app
  end

  def call(env)
    ::BaseApi.call(env)
  end
end
