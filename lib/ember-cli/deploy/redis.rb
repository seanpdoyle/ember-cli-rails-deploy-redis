require "active_support/core_ext/object/blank"
require "ember-cli/deploy/page"
require "redis"

module EmberCLI
  module Deploy
    class Redis
      def initialize(namespace:, index_html: nil, redis_client: build_client)
        @redis_client = redis_client
        @namespace = namespace
        @index_html = index_html
        @body_markup = []
        @head_markup = []
      end

      def append_to_body(markup)
        body_markup << markup
      end

      def append_to_head(markup)
        head_markup << markup
      end

      def html
        if index_html.present?
          page = Page.new(html: index_html)

          body_markup.each do |markup|
            page.append_to_body(markup)
          end

          head_markup.each do |markup|
            page.append_to_head(markup)
          end

          page.build
        else
          index_html_missing!
        end
      end

      private

      attr_reader :body_markup, :head_markup, :namespace, :redis_client

      def index_html
        @index_html ||= redis_client.get(deploy_key).presence
      end

      def current_key
        "#{namespace}:current"
      end

      def deploy_key
        redis_client.get(current_key).presence || deployment_not_activated!
      end

      def build_client
        ::Redis.new(url: ENV.fetch("REDIS_URL"))
      end

      def index_html_missing!
        message = <<-FAIL
        HTML for #{deploy_key} is missing.

        Did you forget to call `ember deploy`?
        FAIL

        raise KeyError, message
      end

      def deployment_not_activated!
        message = <<-FAIL
        #{current_key} is empty.

        Did you forget to call `ember deploy:activate`?
        FAIL

        raise KeyError, message
      end
    end
  end
end
