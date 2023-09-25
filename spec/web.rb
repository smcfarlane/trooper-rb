# frozen_string_literal: true

ENV['NO_AUTOLOAD'] = '1'
Dir['./spec/web/*_spec.rb'].sort.each { |f| require f }
