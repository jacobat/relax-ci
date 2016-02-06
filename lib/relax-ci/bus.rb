require 'observer'

module RelaxCI
  class Bus
    include Observable

    def send_message(message)
      puts "New message on the bus: #{message.to_json}"
      changed
      notify_observers(message)
    end
  end
end
