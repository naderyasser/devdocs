require 'test_helper'
require 'docs'

class BashScraperTest < Minitest::Spec
  describe Docs::Bash do
    it "has correct type" do
      assert_equal 'bash', Docs::Bash.type
    end

    it "has correct release version" do
      assert_equal '5.2', Docs::Bash.release
    end

    it "has correct base_url" do
      assert_equal 'https://www.gnu.org/software/bash/manual/html_node', Docs::Bash.base_url
    end

    it "has correct root_path" do
      assert_equal 'index.html', Docs::Bash.root_path
    end

    it "has correct links" do
      assert_equal 'https://www.gnu.org/software/bash/', Docs::Bash.links[:home]
      assert_equal 'http://git.savannah.gnu.org/cgit/bash.git', Docs::Bash.links[:code]
    end

    it "includes bash/entries filter" do
      assert_includes Docs::Bash.html_filters.to_a, 'bash/entries'
    end

    it "includes bash/clean_html filter" do
      assert_includes Docs::Bash.html_filters.to_a, 'bash/clean_html'
    end

    it "has attribution option set" do
      refute_nil Docs::Bash.options[:attribution]
      assert_includes Docs::Bash.options[:attribution], 'GNU Free Documentation License'
    end

    describe "#get_latest_version" do
      it "returns version number without trailing digit" do
        # Test the version extraction logic
        # This test would normally mock the fetch method
        skip "Requires mocking fetch method"
      end
    end
  end
end
