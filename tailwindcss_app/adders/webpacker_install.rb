# frozen_string_literal: true

require 'singleton'

# determine the version of webpacker to use in template to create rails app
class WebpackerInstall < Thor
  include Singleton

  attr_reader :config

  def self.config
    instance.config
  end

  private

  def initialize
    determine_webpacker_version_to_use
    super
  end

  def determine_webpacker_version_to_use
    webpacker_version = get_webpacker_version
    case webpacker_version
    when :current
      initialize_webpacker_current
    when :next
      initialize_webpacker_next
    else
      raise ArgumentError, "Webpacker version must be :current or :next"
    end
  end

  def get_webpacker_version
    say("\n***\n*** Defaulting to webpacker @next (6.0.0.beta.7)\n***")
    use_vnext = !yes?("*** Use production webpacker v5 instead (N/y)?")
    use_vnext ? :next : :current
  end

  def initialize_webpacker_next
    @config = {
      using_vnext: true,
      gemfile: '6.0.0.beta.7',
      yarn_add: '@rails/webpacker@6.0.0-beta.7',
      js_entrypoint: 'app/packs/entrypoints'
    }
  end

  def initialize_webpacker_current
    @config = {
      using_vnext: false,
      js_entrypoint: 'app/javascript/packs'
      # NOTE: gemfile and yarn configuration is not needed for production webpacker,
      # take defaults by rails new command. As of 6/23/21 the defauls are:
      #   gemfile: '~> 5.0',
      #   yarn_add: '@rails/webpacker',

    }
  end
end
