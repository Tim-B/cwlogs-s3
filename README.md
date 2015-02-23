# cwlogs-s3

Task for exporting CloudWatch logs to S3. Useful for then running logs through EMR for analysis. Designed to be run
 via AWS Data Pipeline.

## Installation

    $ gem install cwlogs-s3

## Usage

```
NAME
    cwlogs-s3 -

USAGE
    cwlogs-s3 [options]

OPTIONS
    --group -g <s>           - Log group name
                               - Log group is required
    --period -p <s>          - Period to export (default: 1 day)
                               - Cannot parse period
    --ending -e <s>          - Time when period ends (default: now)
                               - Cannot parse ending
    --bucket -b <s>          - Destination bucket
                               - Bucket is required
    --prefix -f <s>          - Prefix (default: logs/)
    --region -r <s>          - AWS region (default: us-east-1)
    --verbosity <s>          - Verbosity level of output for current execution
                               (e.g. INFO, DEBUG) (default: WARN)
    --error-output-format <s - The format to use when outputting errors (e.g. b
    >                          asic, advanced) (default: basic)
    --help -h                - Show this message
```

For example:

```
cwlogs-s3 -g "my-app-http-access" -p "3 days" -e "now" -b "my-log-bucket"
```

Which will export all logs in the `my-app-http-access` from the last 3 days ending now to a bucket called `my-log-bucket`.


`--period` Can be formatted according to Chronic Duration: https://github.com/hpoydar/chronic_duration

`--ending` Can be formatted according to Chronic: https://github.com/mojombo/chronic

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cwlogs-s3/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
