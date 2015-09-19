require "spec_helper"
require "ember-cli/deploy/page"

describe EmberCLI::Deploy::Page do
  describe "#build" do
    it "appends to the body" do
      page = build_page("<html><body><h1></h1></body></html>")

      page.append_to_body("<h2></h2>")
      page.append_to_body("<h3></h3>")

      expect(page.build).to eq(
        "<html><body><h1></h1><h2></h2><h3></h3></body></html>"
      )
    end

    it "appends to the head" do
      page = build_page("<html><head><title></title></head></html>")

      page.append_to_head("<meta></meta>")
      page.append_to_head("<script></script>")

      expect(page.build).to eq(
        "<html><head><title></title><meta></meta><script></script></head></html>"
      )
    end
  end
end

def build_page(html)
  EmberCLI::Deploy::Page.new(html: html)
end
