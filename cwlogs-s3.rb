#!/usr/bin/env ruby

require 'escort'
require 'chronic'
require 'chronic_duration'

require './lib/cwlogs-s3_command.rb'

Escort::App.create do |app|

  app.options do |opts|
    opts.opt :group, 'Log group name', :short => '-g', :long => '--group', :type => :string, default: nil
    opts.opt :period, 'Period to export', :short => '-p', :long => '--period', :type => :string, default: '1 day'
    opts.opt :ending, 'Time when period ends', :short => '-e', :long => '--ending', :type => :string, default: 'now'
    opts.opt :bucket, 'Destination bucket', :short => '-b', :long => '--bucket', :type => :string, default: nil
    opts.opt :prefix, 'Prefix', :short => '-f', :long => '--prefix', :type => :string, default: 'logs/'
    opts.opt :region, 'AWS region', :short => '-r', :long => '--region', :type => :string, default: 'us-east-1'

    opts.validate(:period, 'Cannot parse period') { |option| ChronicDuration.parse(option) != nil }
    opts.validate(:ending, 'Cannot parse ending') { |option| Chronic.parse(option) != nil }
    opts.validate(:group, 'Log group is required') { |option| option != nil }
    opts.validate(:bucket, 'Bucket is required') { |option| option != nil }
  end

  app.action do |options, arguments|
    CWLogsS3::CopyToS3.new(options, arguments).execute
  end
end