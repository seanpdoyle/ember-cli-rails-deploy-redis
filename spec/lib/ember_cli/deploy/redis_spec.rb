require "spec_helper"
require "ember_cli/deploy/redis"

describe EmberCli::Deploy::Redis do
  describe "#index_html" do
    context "when the keys are present" do
      it "retrieves the HTML from Redis" do
        stub_index_html(html: "<p>Hello World</p>")
        ember_cli_deploy = build_ember_cli_deploy

        index_html = ember_cli_deploy.index_html

        expect(index_html).to eq("<p>Hello World</p>")
      end
    end

    context "when the current index is missing" do
      it "raises a helpful exception" do
        deploy_key = "abc123"
        stub_index_html(html: nil, deploy_key: deploy_key)
        ember_cli_deploy = build_ember_cli_deploy

        expect { ember_cli_deploy.index_html }.to raise_error(
          /HTML for #{namespace}:#{deploy_key} is missing/
        )
      end
    end

    context "when the current key is unset" do
      it "raises a helpful exception" do
        stub_current_key(nil)
        ember_cli_deploy = build_ember_cli_deploy

        expect { ember_cli_deploy.index_html }.to raise_error(
          /#{namespace}:current is empty/
        )
      end
    end
  end

  around :each do |example|
    with_modified_env REDIS_URL: "redis://localhost:1234" do
      example.run
    end
  end

  def build_ember_cli_deploy
    app = double(name: namespace)
    EmberCli::Deploy::Redis.new(app)
  end

  def namespace
    "ember-cli-rails-deploy-redis"
  end

  def stub_current_key(deploy_key)
    current_key = "#{namespace}:current"

    redis.set(current_key, deploy_key)
  end

  def stub_index_html(deploy_key: "123", html:)
    stub_current_key(deploy_key)
    redis.set("#{namespace}:#{deploy_key}", html)
  end

  def redis
    Redis.new(url: ENV["REDIS_URL"])
  end

  def with_modified_env(options, &block)
    ClimateControl.modify(options, &block)
  end
end
