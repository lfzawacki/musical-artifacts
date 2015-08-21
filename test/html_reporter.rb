require 'builder'
require 'fileutils'

module Minitest
  module Reporters

    class HtmlReporter < BaseReporter
      def initialize(reports_dir = "test/reports", empty = true)
        super({})
        @reports_path = File.absolute_path(reports_dir)
      end

      # Substitute text inside the template
      def substitute_template results
        content = File.read(File.join('test/report_template.html'))

        # Round time to seconds + 2 decimal places
        results[:time] = results[:time].round(2)

        results.each_key do |k|
          content.sub!("{{#{k.to_s}}}", results[k].to_s)
        end
        content
      end

      def report
        super

        puts "Writing HTML reports to public/test_report.html"

        results = analyze_suite(tests)
        suites = tests.group_by(&:class).sort_by do |s, t|
          suite = analyze_suite(t)
          -(suite[:fail_count] + suite[:error_count])
        end

        results[:tests] = ''
        suites.each do |suite, tests|

          suite_results = analyze_suite(tests)
          panel_class = 'panel-default'
          panel_class = 'panel-danger' if (suite_results[:fail_count] + suite_results[:error_count]) > 0

          str =<<HTML
          <div class="panel #{panel_class}">
            <div class="panel-heading">
              #{suite}
            </div>
            <div class="panel-body">
              <ul class="chat">
                {{tests}}
              </ul>
            </div>
          </div>
HTML

          test_str = ''
          tests.each do |test|
            t =<<HTML
            <div class="">
                #{"<p>" + message_for(test) + "</p>"}
            </div>
HTML
            test_str += t
          end

          str.sub!("{{tests}}", test_str)
          results[:tests] += "<div class=\"col-lg-6\">#{str}</div>"
        end

        results[:tests] = "<div class=\"row\">#{results[:tests]}</div>"

        File.open(File.join('public/test_report.html'), "w") do |file|
          file << substitute_template(results)
        end
      end

      private

      def message_for(test)
        # suite = test.class
        name = test.name
        e = test.failure

        if test.passed?
          "<a class=\"btn btn-success btn-circle\">P</a> #{name}"
        elsif test.skipped?
          link, href = location(e)
          "<a href=\"#{href}\" class=\"btn btn-alert btn-circle\">S</a> #{name} [#{link}]"
        elsif test.failure
          link, href = location(e)
          "<a href=\"#{href}\" class=\"btn btn-danger btn-circle\">F</a> #{name} [#{link}]: #{e.message}"
        elsif test.error?
          link, href = location(e)
          "<a href=\"#{href}\" class=\"btn btn-danger btn-circle\">E</a> #{name} [#{link}]: #{e.message}"
        end
      end

      def location(exception)
        last_before_assertion = ''
        exception.backtrace.reverse_each do |s|
          break if s =~ /in .(assert|refute|flunk|pass|fail|raise|must|wont)/
          last_before_assertion = s
        end
        text = last_before_assertion.sub!(/:in .*$/, '')
        href = text.sub(/:([0-9]+)$/, '&line=\1')
        parts = text.split('/')

        if parts.index('test')
          url = parts[parts.index('test'),99].join('/')
        else
          url = text
        end

        ["<a href='txmt://open?url=file://#{href}'>#{url}</a>", "txmt://open?url=file://#{href}"]
      end

      def analyze_suite(tests)
        result = Hash.new(0)
        [:test_count ,:assertion_count, :skip_count, :fail_count, :error_count, :pass_count].each do |k|
          result[k] = 0
        end
        tests.each do |test|
          result[:"#{result(test)}_count"] += 1
          result[:assertion_count] += test.assertions
          result[:test_count] += 1
          result[:time] += test.time
        end
        result
      end

    end
  end
end
