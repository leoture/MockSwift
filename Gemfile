# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'danger', '~> 6.1.0'
gem 'fastlane', '~> 2'
gem 'jazzy', '~> 0.11.0'
gem 'xcpretty', '~> 0.3.0'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
