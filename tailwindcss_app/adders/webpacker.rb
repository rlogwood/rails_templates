# frozen_string_literal: true

require 'singleton'

class Webpacker < Thor
  include Singleton

  attr_reader :config

  def self.config
    instance.config
  end

  def initialize
    say("\n***\n*** Defaulting to webpacker @next (6.0.0.beta.7)\n***")
    #!yes?("*** Use bootstrap v4 instead (N/y)?")
    webpacker_version = :next

    case webpacker_version
    when :current
      initialize_webpacker_current
    when :next
      initialize_webpacker_next
    else
      raise ArgumentError, "Webpacker version must be :current or :next"
    end
    super
  end

  private

  def initialize_webpacker_next
    @config = {
      gemfile: '6.0.0.beta.7',
      yarn_add: '@rails/webpacker@6.0.0-beta.7',
      js_entrypoint: 'app/packs/entrypoints'
    }
  end

  def initialize_webpacker_current
    @config = {
      gemfile: '~> 5.0',
      yarn_add: '@rails/webpacker',
      js_entrypoint: 'app/javascript/packs'
    }
  end
end
