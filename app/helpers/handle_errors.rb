# frozen_string_literal: true

# Api endpoints erros handler
module HandleErrors
  def handle_errors(errors:, code: nil)
    return error!(errors, 422) unless code

    error!(errors, code)
  end
end
