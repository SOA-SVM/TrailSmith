# frozen_string_literal: true

module SVM
  # Provide access to translation data
  class Translation
    def initialize(translated_data)
      @translated = translated_data
    end

    def translations
      @translated['data']['translations']
    end
  end
end
