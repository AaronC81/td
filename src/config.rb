require 'trello'
require 'json'

# Load config constants
module TD
  module Config
    CONFIG_FILE = File.expand_path('~/.config/td')

    class << self
      attr_reader :today_list, :done_label
    end

    def self.load
      # Check the config file exists and load it
      raise "config file does not exist at #{CONFIG_FILE}" unless File.exist?(CONFIG_FILE)
      config_hash = JSON.parse(File.read(CONFIG_FILE))

      # Check keys
      %w[key token todayList doneLabel].each do |required_key|
        raise "key '#{required_key}' not present in config file" unless config_hash[required_key]
      end

      # Configure Trello library
      Trello.configure do |conf|
        conf.developer_public_key = config_hash['key']
        conf.member_token = config_hash['token']
      end

      @today_list = config_hash['todayList']
      @done_label = config_hash['doneLabel']
    end
  end
end
