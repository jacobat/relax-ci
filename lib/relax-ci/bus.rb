require 'observer'

module RelaxCI
  class Bus
    include Observable
    attr_reader :logger

    def initialize(logger)
      @logger = logger
    end

    def send_message(message)
      logger.info "New message on the bus: #{message.to_json}"
      changed
      notify_observers(message)
    end
  end
end
