module Rudis
  class State
    attr_reader :data

    def initialize
      @data = {}
    end

    def set(*args)
      key, value, modifier = *args

      nx = modifier == 'NX'
      xx = modifier == 'XX'
      exists = data.has_key?(key)

      if (!nx && !xx) || (nx && !exists) || (xx && exists)
        data[key] = value
        :ok
      end
    end

    def get(key)
      data[key]
    end

  end
end