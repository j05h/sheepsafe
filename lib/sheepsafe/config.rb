require 'yaml'

module Sheepsafe
  class Config
    FILE = File.expand_path('~/.sheepsafe.yml')
    DEFAULT_CONFIG = {"untrusted_location" => "Untrusted", "socks_port" => "9999"}
    ATTRS = %w(trusted_location untrusted_location last_location ssh_host socks_port)
    ARRAY_ATTRS = %w(trusted_names)

    def self.load_config
      File.open(FILE) {|f| YAML.load(f) }
    rescue
      raise "Unable to read ~/sheepsafe.yml; please run sheepsafe-install"
    end

    attr_reader :config

    def initialize(hash = nil)
      @config = DEFAULT_CONFIG.merge(hash || self.class.load_config)
    end

    ATTRS.each do |m|
      define_method(m) { config[m] }
      define_method("#{m}=") {|v| config[m] = v}
    end

    ARRAY_ATTRS.each do |m|
      define_method(m) { config[m] ||= [] }
      define_method("#{m}=") {|v| config[m] = [v].flatten}
    end

    def write
      File.open(FILE, "w") {|f| f << YAML.dump(@config) }
    end
  end
end
