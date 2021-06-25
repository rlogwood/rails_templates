require 'singleton'

class BootstrapConfig < Thor
  include Singleton
  attr_reader :use_bootstrap_v5, :use_jquery

  def initialize
    @use_bootstrap_v5 = use_bootstrap_v5?
    @use_jquery = !@use_bootstrap_v5 || use_jquery_with_bs5?
    super
  end

  def self.bootstrap_v5?
    instance.use_bootstrap_v5
  end

  def self.use_jquery?
    instance.use_jquery
  end

  def self.bootstrap_version_name
    bootstrap_v5? ? "v5" : "v4"
  end

  def self.bootstrap_choice_description
    version = instance.use_bootstrap_v5 ? "v5" : "v4"
    jquery =  instance.use_jquery ? "will be added (#{instance.use_bootstrap_v5 ? "requested for v5" : "required for v4"})" : "is not needed"
    "\n***\n*** Using Bootstrap #{version}\n*** jQuery #{jquery}\n***\n"
  end

  private

  def env_defines_bootstrap_v5?
    ENV['BOOTSTRAP_VERSION'] == '5'
  end

  def env_defines_bootstrap_v4?
    ENV['BOOTSTRAP_VERSION'] == '4'
  end

  def env_defines_use_jquery?
    ENV.key?('USE_JQUERY')
  end

  def env_requests_jquery?
    ENV['USE_JQUERY'] =~ /y|ye|yes/i
  end

  def use_bootstrap_v5?
    return true if env_defines_bootstrap_v5?
    return false if env_defines_bootstrap_v4?

    say("\n***\n*** Default bootstrap is v5\n***")
    !yes?("*** Use bootstrap v4 instead (N/y)?")
  end

  def use_jquery_with_bs5?
    return env_requests_jquery? if env_defines_use_jquery?

    say("***\n*** You've chosen bootstrap 5, jQuery will only be loaded if you request it\n***")
    yes?("*** Do you want to add jQuery to bootstrap 5 (N/y)?")
  end
end
