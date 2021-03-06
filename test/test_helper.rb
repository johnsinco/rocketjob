$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
ENV['TZ'] = 'America/New_York'

require 'yaml'
require 'minitest/autorun'
require 'minitest/stub_any_instance'
require 'minitest/reporters'
require 'awesome_print'
require 'rocketjob'

SemanticLogger.add_appender(file_name: 'test.log', formatter: :color)
SemanticLogger.default_level = :info

RocketJob::Config.load!('test', 'test/config/mongoid.yml')
Mongoid.logger       = SemanticLogger[Mongoid]
Mongo::Logger.logger = SemanticLogger[Mongo]

# Cleanup test collections
RocketJob::Job.collection.database.collections.each do |collection|
  next if collection.capped?
  collection.drop
end

reporters = [
  Minitest::Reporters::ProgressReporter.new,
  SemanticLogger::Reporters::Minitest.new
]
Minitest::Reporters.use!(reporters)

