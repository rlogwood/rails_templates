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
    bootstrap_v5? ? "v(5/next)" : "v4"
  end

  def self.bootstrap_choice_description
    version = instance.use_bootstrap_v5 ? "v5 @next" : "v4"
    jquery =  instance.use_jquery ? "will be added" : "is not needed"
    "\n***\n*** Using Bootstrap #{version}\n*** jQuery #{jquery}\n***\n"
  end

  private

  def use_bootstrap_v5?
    if ENV.key?('USE_BOOTSTRAP_4')
      false
    elsif ENV.key?('USE_BOOTSTRAP_5')
      true
    else
      say("\n***\n*** Default bootstrap is v5 @next (5.0.0-beta3)\n***")
      !yes?("*** Use bootstrap v4 instead (N/y)?")
    end
  end

  def use_jquery_with_bs5?
    if ENV.key?('USE_JQUERY')
      return true
    end
    say("***\n*** You've chosen bootstrap 5, jQuery will only be loaded if you request it\n***")
    yes?("*** Do you want to add jQuery to bootstrap 5 (needed for tool tips) (N/y)?")
  end

end
