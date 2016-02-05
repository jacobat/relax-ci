module RelaxCI
  module Triggers
    class Github
      class << self
        def trigger(payload)
          puts payload
        end
      end
    end
  end
end
