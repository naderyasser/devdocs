require 'test_helper'
require 'docs'

class BashCleanHtmlFilterTest < Minitest::Spec
  include FilterTestHelper
  self.filter_class = Docs::Bash::CleanHtmlFilter

  describe "clean_html filter" do
    it "removes navigation header and hr" do
      @body = <<-HTML
        <div>
          <hr>
          <div class="header">Navigation</div>
          <hr>
          <h1>Title</h1>
        </div>
      HTML

      result = filter_output_string
      refute_includes result, 'Navigation'
      refute_includes result, 'header'
    end

    it "removes copiable-anchor elements" do
      @body = <<-HTML
        <div>
          <h1>Title<a class="copiable-anchor" href="#anchor">¶</a></h1>
        </div>
      HTML

      result = filter_output_string
      refute_includes result, 'copiable-anchor'
    end

    it "removes chapter numbers from title and converts to h1" do
      @body = '<h3>3.2.1 Command Substitution</h3>'
      result = filter_output_string
      assert_includes result, '<h1>Command Substitution</h1>'
      refute_includes result, '3.2.1'
    end

    it "removes 'D. ' prefix from appendix titles" do
      @body = '<h1>D. Concept Index</h1>'
      result = filter_output_string
      assert_includes result, '<h1>Concept Index</h1>'
      refute_includes result, 'D.'
    end

    it "removes single-space table columns" do
      @body = <<-HTML
        <table>
          <tr>
            <td>Column 1</td>
            <td> </td>
            <td>Column 2</td>
          </tr>
        </table>
      HTML

      doc = filter_result
      assert_equal 2, doc.css('td').length
    end

    it "adds id attributes to code nodes in dt elements" do
      @body = <<-HTML
        <dl>
          <dt><code>export</code></dt>
          <dd>Description</dd>
        </dl>
      HTML

      doc = filter_result
      code_node = doc.at_css('dt > code')
      assert_equal 'export', code_node['id']
    end

    it "fixes hashes of index entries" do
      @body = <<-HTML
        <table class="index-fn">
          <td valign="top"><a href="page.html#old">function_name</a></td>
        </table>
      HTML

      doc = filter_result
      link = doc.at_css('a')
      assert_equal 'page.html#function_name', link['href']
    end

    it "fixes special parameters index entries" do
      @body = <<-HTML
        <table class="index-vr">
          <td valign="top"><a href="Special-Parameters.html#hash">$!</a></td>
        </table>
      HTML

      doc = filter_result
      link = doc.at_css('a')
      assert_equal 'Special-Parameters.html#!', link['href']
    end

    it "converts tt tags to code tags" do
      @body = '<p>Use <tt>command</tt> here</p>'
      result = filter_output_string
      assert_includes result, '<code>command</code>'
      refute_includes result, '<tt>'
    end

    it "removes class attributes from code and table tags" do
      @body = <<-HTML
        <code class="language-bash">echo</code>
        <table class="fancy-table">
          <tr><td>data</td></tr>
        </table>
      HTML

      doc = filter_result
      refute doc.at_css('code')['class']
      refute doc.at_css('table')['class']
    end

    it "preserves pre tag content as text" do
      @body = <<-HTML
        <pre><code class="highlight">
          echo "hello"
        </code></pre>
      HTML

      doc = filter_result
      pre_node = doc.at_css('pre')
      # Should not have nested tags, just text content
      assert_equal 0, pre_node.css('code').length
    end

    it "sets id on index table letter hashes" do
      @body = <<-HTML
        <table class="index-cp">
          <th><a name="t_a">A</a></th>
        </table>
      HTML

      doc = filter_result
      link = doc.at_css('th > a')
      assert_equal 't_a', link['id']
    end

    it "removes colspan rows from index tables" do
      @body = <<-HTML
        <table class="index-fn">
          <tr><td colspan="4"><hr></td></tr>
          <tr><td>actual content</td></tr>
        </table>
      HTML

      doc = filter_result
      refute doc.at_css('td[colspan="4"]')
    end

    it "simplifies menu entry cells to contain only links" do
      @body = <<-HTML
        <td valign="top">
          <a href="page.html">Link</a>
          <span>: Extra text</span>
        </td>
      HTML

      doc = filter_result
      td = doc.at_css('td[valign="top"]')
      assert_equal 1, td.children.length
      assert_equal 'a', td.children.first.name
    end

    it "uses div with id as root if present" do
      @body = <<-HTML
        <div>
          <div id="main-content">
            <h1>Title</h1>
          </div>
        </div>
      HTML

      doc = filter_result
      assert_equal 'main-content', doc['id']
    end
  end
end
