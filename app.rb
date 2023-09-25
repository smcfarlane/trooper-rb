# frozen_string_literal: true

require_relative 'models'

require 'roda'

require 'tilt'
require 'tilt/erubi'
require_relative 'helpers/application_helper'

class Trooper < Roda
  opts[:check_dynamic_arity] = false
  opts[:check_arity] = :warn

  plugin :default_headers,
         'Content-Type' => 'text/html',
         'X-Frame-Options' => 'deny',
         'X-Content-Type-Options' => 'nosniff',
         'X-XSS-Protection' => '1; mode=block'

  plugin :content_security_policy do |csp|
    csp.default_src :none
    csp.style_src :self, :'unsafe-inline', 'https://rare-krill-93.clerk.accounts.dev'
    csp.form_action :self, 'https://rare-krill-93.clerk.accounts.dev'
    csp.script_src :self, 'https://rare-krill-93.clerk.accounts.dev'
    csp.connect_src :self, 'https://rare-krill-93.clerk.accounts.dev'
    csp.base_uri :none
    csp.frame_ancestors :none
    csp.worker_src 'blob:', 'https://rare-krill-93.clerk.accounts.dev'
    csp.img_src :self, 'https://img.clerk.com'
  end

  css_opts = { cache: false, style: :compressed }
  # :nocov:
  plugin :render_coverage if defined?(SimpleCov)
  # :nocov:

  plugin :flash
  plugin :assets,
         js: 'build/main.js',
         css: 'build/main.css',
         css_opts: css_opts,
         timestamp_paths: true
  plugin :render, escape: true, layout: './layout',
                  template_opts: { chain_appends: !defined?(SimpleCov), freeze: true, skip_compiled_encoding_detection: true }
  plugin :render_each
  plugin :partials, views: 'views'
  plugin :public
  plugin :Integer_matcher_max
  plugin :typecast_params_sized_integers, sizes: [64], default_size: 64
  plugin :hash_branch_view_subdir

  logger = if ENV['RACK_ENV'] == 'test'
             Class.new { def write(_) end }.new
           else
             AppLogger
           end
  plugin :common_logger, logger

  plugin :not_found do
    @page_title = 'File Not Found'
    view(content: '')
  end

  if ENV['RACK_ENV'] == 'development'
    plugin :exception_page
    class RodaRequest
      def assets
        exception_page_assets
        super
      end
    end
  else
    def self.freeze
      Sequel::Model.freeze_descendents
      DB.freeze
      super
    end
  end

  plugin :error_handler do |e|
    $stderr.print "#{e.class}: #{e.message}\n"
    warn e.backtrace
    next exception_page(e, assets: true) if ENV['RACK_ENV'] == 'development'

    @page_title = 'Internal Server Error'
    view(content: '')
  end

  plugin :sessions,
         key: '_Trooper.session',
         # cookie_options: {secure: ENV['RACK_ENV'] != 'test'}, # Uncomment if only allowing https:// access
         secret: ENV.send((ENV['RACK_ENV'] == 'development' ? :[] : :delete), 'TROOPER_SESSION_SECRET')

  if Unreloader.autoload?
    plugin :autoload_hash_branches
    autoload_hash_branch_dir('./routes')
  end
  Unreloader.autoload('routes', delete_hook: proc { |f| hash_branch(File.basename(f).delete_suffix('.rb')) }) {}

  include ApplicationHelper

  route do |r|
    r.public
    r.assets

    r.hash_branches('')

    r.root do
      view 'index'
    end

    r.is 'sign_in' do
      view 'users/sign_in'
    end

    r.is 'sign_out' do
      r.delete do
      end
    end

    r.is 'sign_up' do
      view 'users/sign_up'
    end
  end
end
