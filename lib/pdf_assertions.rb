# PDF Assertions for Lessig-Hardt Slide Generator Tests
# Uses pdf-reader gem to extract and verify slide content

require 'pdf-reader'

module PDFAssertions
  class AssertionError < StandardError; end

  # Extract text from each page of a PDF
  def self.extract_pages(pdf_path)
    reader = PDF::Reader.new(pdf_path)
    reader.pages.map { |page| page.text.strip }
  end

  # Parse expected assertions from a test file
  # Format: Lines starting with #EXPECT: define assertions
  # #EXPECT: page=1 contains="Title Text"
  # #EXPECT: page=2 contains="Body Text"
  # #EXPECT: pages=3
  def self.parse_expectations(test_file)
    expectations = []
    File.readlines(test_file).each do |line|
      if line.start_with?('#EXPECT:')
        expectation = parse_expectation_line(line.sub('#EXPECT:', '').strip)
        expectations << expectation if expectation
      end
    end
    expectations
  end

  # Parse a single expectation line
  def self.parse_expectation_line(line)
    expectation = {}

    # Parse key=value pairs
    line.scan(/(\w+)=(?:"([^"]+)"|(\S+))/) do |key, quoted_val, unquoted_val|
      value = quoted_val || unquoted_val
      expectation[key.to_sym] = value
    end

    return nil if expectation.empty?
    expectation
  end

  # Run assertions against a PDF
  def self.verify(pdf_path, expectations)
    pages = extract_pages(pdf_path)
    errors = []

    expectations.each do |exp|
      if exp[:pages]
        # Check total page count
        expected_count = exp[:pages].to_i
        if pages.length != expected_count
          errors << "Expected #{expected_count} pages, got #{pages.length}"
        end
      end

      if exp[:page] && exp[:contains]
        # Check specific page contains text
        page_num = exp[:page].to_i
        expected_text = exp[:contains]

        if page_num < 1 || page_num > pages.length
          errors << "Page #{page_num} does not exist (only #{pages.length} pages)"
        else
          page_text = pages[page_num - 1]
          # Normalize whitespace for comparison
          # PDF text extraction can insert spurious spaces within words
          # We collapse all whitespace and compare without spaces for robustness
          normalized_page = page_text.gsub(/\s+/, '')
          normalized_expected = expected_text.gsub(/\s+/, '')

          unless normalized_page.include?(normalized_expected)
            errors << "Page #{page_num}: expected to contain \"#{expected_text}\"\n  Got: \"#{page_text.gsub("\n", "\\n")[0..200]}...\""
          end
        end
      end

      if exp[:page] && exp[:not_contains]
        # Check specific page does NOT contain text
        page_num = exp[:page].to_i
        forbidden_text = exp[:not_contains]

        if page_num >= 1 && page_num <= pages.length
          page_text = pages[page_num - 1]
          if page_text.include?(forbidden_text)
            errors << "Page #{page_num}: should NOT contain \"#{forbidden_text}\""
          end
        end
      end
    end

    errors
  end

  # Convenience method: verify and raise if errors
  def self.verify!(pdf_path, expectations)
    errors = verify(pdf_path, expectations)
    unless errors.empty?
      raise AssertionError, errors.join("\n")
    end
    true
  end
end
