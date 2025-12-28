require 'test_helper'
require 'docs'

class ApiDocumentationTest < Minitest::Spec
  describe "API Documentation Links and Structure" do

    describe "scraper reference documentation" do
      it "exists and is readable" do
        doc_path = File.join(Docs.root, 'docs', 'scraper-reference.md')
        assert File.exist?(doc_path), "scraper-reference.md should exist"
        assert File.readable?(doc_path), "scraper-reference.md should be readable"
      end

      it "contains required sections" do
        doc_path = File.join(Docs.root, 'docs', 'scraper-reference.md')
        content = File.read(doc_path)

        assert_includes content, '## Overview'
        assert_includes content, '## Configuration'
        assert_includes content, '### Attributes'
        assert_includes content, '### Filter stacks'
        assert_includes content, '### Filter options'
      end

      it "documents all core filter options" do
        doc_path = File.join(Docs.root, 'docs', 'scraper-reference.md')
        content = File.read(doc_path)

        # Verify key filter options are documented
        assert_includes content, ':container'
        assert_includes content, ':attribution'
        assert_includes content, ':skip_patterns'
        assert_includes content, ':only_patterns'
      end
    end

    describe "filter reference documentation" do
      it "exists and is readable" do
        doc_path = File.join(Docs.root, 'docs', 'filter-reference.md')
        assert File.exist?(doc_path), "filter-reference.md should exist"
        assert File.readable?(doc_path), "filter-reference.md should be readable"
      end

      it "contains required sections" do
        doc_path = File.join(Docs.root, 'docs', 'filter-reference.md')
        content = File.read(doc_path)

        assert_includes content, '## Overview'
        assert_includes content, '## Instance methods'
        assert_includes content, '## Core filters'
        assert_includes content, '## Custom filters'
      end

      it "documents core filters" do
        doc_path = File.join(Docs.root, 'docs', 'filter-reference.md')
        content = File.read(doc_path)

        # Verify all core filters are mentioned
        assert_includes content, 'ContainerFilter'
        assert_includes content, 'CleanHtmlFilter'
        assert_includes content, 'NormalizeUrlsFilter'
        assert_includes content, 'InternalUrlsFilter'
        assert_includes content, 'AttributionFilter'
        assert_includes content, 'EntriesFilter'
      end

      it "documents filter instance methods" do
        doc_path = File.join(Docs.root, 'docs', 'filter-reference.md')
        content = File.read(doc_path)

        # Verify key instance methods are documented
        assert_includes content, '* `doc`'
        assert_includes content, '* `html`'
        assert_includes content, '* `context`'
        assert_includes content, '* `result`'
      end
    end

    describe "adding docs guide" do
      it "exists and is readable" do
        doc_path = File.join(Docs.root, 'docs', 'adding-docs.md')
        assert File.exist?(doc_path), "adding-docs.md should exist"
        assert File.readable?(doc_path), "adding-docs.md should be readable"
      end
    end

    describe "core filter classes" do
      it "all documented filters exist as classes" do
        filter_classes = [
          Docs::ContainerFilter,
          Docs::CleanHtmlFilter,
          Docs::NormalizeUrlsFilter,
          Docs::InternalUrlsFilter,
          Docs::NormalizePathsFilter,
          Docs::InnerHtmlFilter,
          Docs::CleanTextFilter,
          Docs::AttributionFilter,
          Docs::TitleFilter,
          Docs::EntriesFilter
        ]

        filter_classes.each do |filter_class|
          assert filter_class, "#{filter_class} should be defined"
          assert filter_class < Docs::Filter, "#{filter_class} should inherit from Docs::Filter"
        end
      end
    end

    describe "scraper base classes" do
      it "UrlScraper exists and is properly defined" do
        assert Docs::UrlScraper
        assert Docs::UrlScraper < Docs::Scraper
      end

      it "FileScraper exists and is properly defined" do
        assert Docs::FileScraper
        assert Docs::FileScraper < Docs::Scraper
      end
    end

    describe "documentation consistency" do
      it "all scrapers referenced in docs exist" do
        # This test would verify that scrapers mentioned in documentation
        # actually exist in the codebase
        skip "Requires parsing documentation and cross-referencing with codebase"
      end

      it "all filters referenced in docs exist" do
        # This test would verify that filters mentioned in documentation
        # actually exist in the codebase
        skip "Requires parsing documentation and cross-referencing with codebase"
      end
    end

    describe "GitHub links in documentation" do
      it "scraper-reference contains valid GitHub links" do
        doc_path = File.join(Docs.root, 'docs', 'scraper-reference.md')
        content = File.read(doc_path)

        # Verify GitHub links are present
        assert_match /github\.com\/freeCodeCamp\/devdocs/, content
      end

      it "filter-reference contains valid GitHub links" do
        doc_path = File.join(Docs.root, 'docs', 'filter-reference.md')
        content = File.read(doc_path)

        # Verify GitHub links are present
        assert_match /github\.com\/freeCodeCamp\/devdocs/, content
      end
    end

    describe "external API references" do
      it "documents Nokogiri usage" do
        doc_path = File.join(Docs.root, 'docs', 'filter-reference.md')
        content = File.read(doc_path)

        assert_includes content, 'Nokogiri'
      end

      it "documents HTML::Pipeline usage" do
        doc_path = File.join(Docs.root, 'docs', 'scraper-reference.md')
        content = File.read(doc_path)

        assert_includes content, 'HTML::Pipeline'
      end

      it "documents Typhoeus usage" do
        doc_path = File.join(Docs.root, 'docs', 'scraper-reference.md')
        content = File.read(doc_path)

        assert_includes content, 'Typhoeus'
      end
    end
  end
end
