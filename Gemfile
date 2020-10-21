# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'danger', '~> 8.1'
gem 'danger-swiftformat', '~> 0.7'
gem 'danger-swiftlint', '~> 0.24'
gem 'fastlane', '~> 2.146'
gem 'jazzy', '~> 0.13'
gem 'slather', '~> 2.5'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
