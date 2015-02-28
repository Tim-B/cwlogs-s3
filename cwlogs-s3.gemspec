# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "cwlogs-s3"
  spec.version       = '0.0.5'
  spec.authors       = ["Tim-B"]
  spec.email         = ["tim@galacticcode.com"]
  spec.summary       = %q{Exports logs from CloudWatch logs and uploads them to S3}
  spec.description   = %q{Exports logs from CloudWatch logs and uploads them to S3}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency 'escort', '~> 0.4.0'
  spec.add_runtime_dependency 'aws-sdk', '~> 2.0.27'
  spec.add_runtime_dependency 'chronic_duration', '~> 0.10.6'
  spec.add_runtime_dependency 'chronic', '~> 0.10.2'
end
