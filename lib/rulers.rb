# frozen_string_literal: true

require_relative "rulers/version"
require 'rulers/array'
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"

module Rulers
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      if env['PATH_INFO'] == '/'
        env['PATH_INFO'] = '/home/index'
      end

      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      begin
        text = controller.send(act)
      rescue StandardError => e
        return [500, {'Content-Type' => 'text/html'}, [e]]
      end

      [200, {'Content-Type' => 'text/html'}, [text]]
    end
  end
end
