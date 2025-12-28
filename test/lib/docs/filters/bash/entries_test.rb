require 'test_helper'
require 'docs'

class BashEntriesFilterTest < Minitest::Spec
  include FilterTestHelper
  self.filter_class = Docs::Bash::EntriesFilter

  describe "#get_name" do
    it "extracts name from h1" do
      @body = '<h1>3.2 Bash Builtin Commands</h1>'
      assert_equal 'Bash Builtin Commands', filter.get_name
    end

    it "removes numbering from name" do
      @body = '<h1>6.11 Aliases</h1>'
      assert_equal 'Aliases', filter.get_name
    end

    it "handles appendix notation" do
      @body = '<h1>D. Indexes</h1>'
      assert_equal 'Appendix Indexes', filter.get_name
    end

    it "removes E. notation for appendixes" do
      @body = '<h1>E.2.1 History Variables</h1>'
      assert_equal 'History Variables', filter.get_name
    end

    it "strips whitespace from name" do
      @body = '<h1>  10.1  Job Control Basics  </h1>'
      assert_equal 'Job Control Basics', filter.get_name
    end
  end

  describe "#get_type" do
    it "returns 'Manual: Appendices' for appendix pages" do
      @body = '<h1>Appendix A: Sample</h1>'
      assert_equal 'Manual: Appendices', filter.get_type
    end

    it "returns 'Manual: Indexes' for index pages" do
      @body = '<h1>Function Index</h1><a rel="up">Index</a>'
      assert_equal 'Manual: Indexes', filter.get_type
    end

    it "returns 'Manual' for regular pages" do
      @body = '<h1>Shell Commands</h1><a rel="up">Manual</a>'
      assert_equal 'Manual', filter.get_type
    end
  end

  describe "#additional_entries" do
    it "extracts entries from Function Index" do
      @body = <<-HTML
        <h1>Function Index</h1>
        <table class="index-fn">
          <tr>
            <td valign="top"><a href="page1.html#func1">func1</a></td>
            <td valign="top"><a href="section1.html">Section</a></td>
            <td valign="top"><a href="page2.html#func2">func2</a></td>
            <td valign="top"><a href="section2.html">Section</a></td>
          </tr>
        </table>
      HTML

      entries = filter.additional_entries
      assert_equal 2, entries.length
      assert_equal ['func1', 'page1.html#func1', 'Functions'], entries[0]
      assert_equal ['func2', 'page2.html#func2', 'Functions'], entries[1]
    end

    it "extracts entries from Index of Shell Builtin Commands" do
      @body = <<-HTML
        <h1>Index of Shell Builtin Commands</h1>
        <table class="index-cp">
          <tr>
            <td valign="top"><a href="builtins.html#echo">echo</a></td>
            <td valign="top"><a href="section.html">Section</a></td>
          </tr>
        </table>
      HTML

      entries = filter.additional_entries
      assert_equal 1, entries.length
      assert_equal ['echo', 'builtins.html#echo', 'Builtin Commands'], entries[0]
    end

    it "returns empty array for non-index pages" do
      @body = '<h1>Regular Page</h1>'
      assert_equal [], filter.additional_entries
    end
  end
end
