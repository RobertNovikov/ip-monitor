# frozen_string_literal: true

require File.expand_path('config/environment', __dir__)
require './config/application'

run App.instance
