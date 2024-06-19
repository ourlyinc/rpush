module Rpush
  module Daemon
    module Dispatcher
      class Http
        def initialize(app, delivery_class, _options = {})
          @app = app
          @delivery_class = delivery_class
          @http = Net::HTTP::Persistent.new(name: 'rpush').tap do |http|
            http.debug_output = Rpush.config.logger if Rpush.config.log_level == ::Logger::Severity::DEBUG
          end
        end

        def dispatch(payload)
          @delivery_class.new(@app, @http, payload.notification, payload.batch).perform
        end

        def cleanup
          @http.shutdown
        end
      end
    end
  end
end
