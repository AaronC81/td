#!/usr/bin/env ruby

require_relative 'config'
require_relative 'item'
require_relative 'data'
require_relative 'cli'

TD::Config.load

TD::CLI.run(ARGV)
