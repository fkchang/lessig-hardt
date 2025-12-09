# Rakefile for Lessig-Hardt Slide Generator

require 'fileutils'

SCRIPT_DIR = File.dirname(__FILE__)
TEST_DIR = File.join(SCRIPT_DIR, 'tests')
OUTPUT_DIR = File.join(SCRIPT_DIR, 'test_output')

desc "Run all tests (default)"
task :default => :test

desc "Run all tests"
task :test do
  FileUtils.mkdir_p(OUTPUT_DIR)

  test_files = Dir.glob(File.join(TEST_DIR, '*.txt'))

  if test_files.empty?
    puts "No test files found in #{TEST_DIR}"
    exit 1
  end

  puts "Running #{test_files.length} tests"
  puts "=" * 40

  passed = 0
  failed = 0

  test_files.each do |test_file|
    test_name = File.basename(test_file, '.txt')
    output_pdf = File.join(OUTPUT_DIR, "#{test_name}.pdf")

    print "Testing #{test_name}... "

    result = system("osascript #{SCRIPT_DIR}/slide_generator_cli.scpt '#{test_file}' > /dev/null 2>&1")

    # Export the open document to PDF and close it
    export_script = <<~APPLESCRIPT
      tell application "Keynote"
        if (count of documents) > 0 then
          set doc to document 1
          export doc to POSIX file "#{output_pdf}" as PDF
          close doc saving no
        end if
      end tell
    APPLESCRIPT

    system("osascript -e '#{export_script}' 2>/dev/null")

    if File.exist?(output_pdf)
      puts "✓"
      passed += 1
    else
      puts "✗"
      failed += 1
    end
  end

  puts "=" * 40
  puts "Passed: #{passed}, Failed: #{failed}"
  puts "Output PDFs: #{OUTPUT_DIR}"

  exit(failed > 0 ? 1 : 0)
end

desc "Run a single test"
task :test_one, [:name] do |t, args|
  name = args[:name]
  abort "Usage: rake test_one[test_name]" unless name

  FileUtils.mkdir_p(OUTPUT_DIR)

  test_file = File.join(TEST_DIR, "#{name}.txt")
  test_file = File.join(TEST_DIR, name) unless File.exist?(test_file)

  abort "Test file not found: #{name}" unless File.exist?(test_file)

  test_name = File.basename(test_file, '.txt')
  output_pdf = File.join(OUTPUT_DIR, "#{test_name}.pdf")

  puts "Running test: #{test_name}"

  system("osascript #{SCRIPT_DIR}/slide_generator_cli.scpt '#{test_file}'")

  # Export and close
  export_script = <<~APPLESCRIPT
    tell application "Keynote"
      if (count of documents) > 0 then
        set doc to document 1
        export doc to POSIX file "#{output_pdf}" as PDF
        close doc saving no
      end if
    end tell
  APPLESCRIPT

  system("osascript -e '#{export_script}'")

  if File.exist?(output_pdf)
    puts "Generated: #{output_pdf}"
    system("open '#{output_pdf}'")
  else
    puts "Failed to generate PDF"
  end
end

desc "Compile AppleScript source to .scpt"
task :compile do
  sources = ['slide_generator', 'slide_generator_cli']

  sources.each do |name|
    src = File.join(SCRIPT_DIR, "#{name}.applescript")
    dst = File.join(SCRIPT_DIR, "#{name}.scpt")

    if File.exist?(src)
      print "Compiling #{name}... "
      if system("osacompile -o '#{dst}' '#{src}' 2>/dev/null")
        puts "✓"
      else
        puts "✗"
      end
    end
  end
end

desc "Clean test output"
task :clean do
  FileUtils.rm_rf(OUTPUT_DIR)
  puts "Cleaned #{OUTPUT_DIR}"
end

desc "Generate presentation from file"
task :generate, [:file] do |t, args|
  file = args[:file]
  abort "Usage: rake generate[path/to/slides.txt]" unless file
  abort "File not found: #{file}" unless File.exist?(file)

  puts "Generating presentation from: #{file}"
  system("osascript #{SCRIPT_DIR}/slide_generator_cli.scpt '#{file}'")
end
