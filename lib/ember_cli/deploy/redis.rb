require "active_support/core_ext/object/blank"
require "redis"

module EmberCli
  module Deploy
    class Redis
      def initialize(app)
        @app = app
      end

      def index_html
        redis_client.get(deploy_key).presence || index_html_missing!
      end

      private

      attr_reader :app

      def redis_client
        @redis_client ||= ::Redis.new(url: ENV.fetch("REDIS_URL"))
      end

      def namespace
        app.name
      end

      def current_key
        "#{namespace}:current"
      end

      def deploy_key
        key = redis_client.get(current_key).presence ||
              deployment_not_activated!

        "#{namespace}:#{key}"
      end

      def index_html_missing!
        raise KeyError.new <<-FAIL
        HTML for #{deploy_key} is missing.

        Did you forget to call `ember deploy`?
        FAIL
      end

      def deployment_not_activated!
        raise KeyError.new <<-FAIL
        #{current_key} is empty.

        Did you forget to call `ember deploy:activate`?
        FAIL
      end
    end
  end
end
