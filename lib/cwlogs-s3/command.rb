require 'escort'
require 'chronic'
require 'chronic_duration'
require 'aws-sdk'
require 'securerandom'
require 'uri'

module CWLogsToS3

  class Command < ::Escort::ActionCommand::Base

    def execute

      @event_cnt = 0
      @page_cnt = 0

      ending = Chronic.parse(command_options[:ending])
      period = ChronicDuration.parse(command_options[:period])
      start = Time.at(ending.to_i - period)

      s3Uri = URI(command_options[:s3_path])
      @bucket = s3Uri.host
      @s3_prefix = s3Uri.path.gsub!(/^\//, '')

      Escort::Logger.output.puts "Exporting from #{start} to #{ending}"

      @cwl = Aws::CloudWatchLogs::Client.new(region: command_options[:region])
      @s3 = Aws::S3::Resource.new(region: command_options[:region])

      @stream_list = []

      resp = @cwl.describe_log_streams(
          log_group_name: command_options[:group],
      )

      start_ms = start.to_i * 1000
      end_ms = ending.to_i * 1000

      resp.each do |streams|
        streams[:log_streams].each do |stream|
          next if stream[:last_event_timestamp] < start_ms
          next if end_ms < stream[:first_event_timestamp]
          @stream_list.push stream[:log_stream_name]
        end
      end

      Escort::Logger.output.puts "Exporting streams #{@stream_list.join(', ')}"

      page = 0

      @stream_list.each do |stream|
        Escort::Logger.output.puts "Starting stream #{stream}"
        resp = @cwl.get_log_events(
            log_group_name: command_options[:group],
            log_stream_name: stream,
            start_time: start_ms,
            end_time: end_ms,
            start_from_head: true
        )

        resp.each do |log_page|
          if log_page[:events].length == 0
            break
          end
          put_page log_page[:events]
        end
      end

      Escort::Logger.output.puts "Finished, #{@event_cnt} events extracted."
    end

    def put_page events
      page_content = ''
      events.each do |event|
        @event_cnt = @event_cnt + 1
        page_content << event[:message] << "\n"
      end
      object_name = @s3_prefix + randomise_prefix + '_' + @page_cnt.to_s + '.log'
      @s3.bucket(@bucket).object(object_name).put(
          :body => page_content
      )
      Escort::Logger.output.puts "Put #{object_name} to S3."
      @page_cnt = @page_cnt + 1
    end

    def randomise_prefix
      SecureRandom.hex(2).to_s
    end

  end

end