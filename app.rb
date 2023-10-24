# frozen_string_literal: true

require_relative 'models'

require 'roda'

require 'tilt'
require 'haml'
require 'tilt/haml'
require_relative 'plugins/htmx'
$LOAD_PATH.unshift(File.expand_path('helpers', __dir__))
Dir['helpers/**/*.rb'].each { |f| require_relative f.delete_suffix('.rb') }

class Trooper < Roda
  opts[:check_dynamic_arity] = false
  opts[:check_arity] = :warn

  plugin :default_headers,
         'Content-Type' => 'text/html',
         'X-Frame-Options' => 'deny',
         'X-Content-Type-Options' => 'nosniff',
         'X-XSS-Protection' => '1; mode=block'

  plugin :content_security_policy do |csp|
    csp.default_src :self, 'https://fonts.googleapis.com'
    csp.font_src :self, 'https://fonts.gstatic.com'
    csp.style_src :self, :'unsafe-inline', 'https://fonts.googleapis.com'
    csp.form_action :self
    csp.script_src :self
    csp.connect_src :self
    csp.base_uri :none
    csp.frame_ancestors :none
    csp.img_src :self
  end

  css_opts = {
    cache: ENV['RACK_ENV'] != 'development',
    style: :compressed,
    source_map_embed: true,
    source_map_contents: true,
    source_map_file: '.'
  }
  # :nocov:
  plugin :render_coverage if defined?(SimpleCov)
  # :nocov:

  plugin :flash
  plugin :assets,
         js: 'build/main-build.js',
         css: 'build/main-build.css',
         css_opts: css_opts,
         timestamp_paths: true
  plugin :render,
         escape: true,
         engine: 'haml',
         layout: './layout',
         template_opts: {
           chain_appends: !defined?(SimpleCov),
           freeze: true, skip_compiled_encoding_detection: true
         }
  plugin :render_each
  plugin :partials, views: 'views'
  plugin :htmx
  plugin :public, gzip: true
  plugin :Integer_matcher_max
  plugin :typecast_params_sized_integers, sizes: [64], default_size: 64
  plugin :hash_branch_view_subdir
  plugin :plain_hash_response_headers
  plugin :request_headers

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
  # rubocop:disable Lint/EmptyBlock
  Unreloader.autoload('routes', delete_hook: proc { |f| hash_branch(File.basename(f).delete_suffix('.rb')) }) {}
  # rubocop:enable Lint/EmptyBlock

  include ApplicationHelper

  route do |r|
    r.public
    r.assets

    r.hash_branches('')

    r.root do
      hx_render 'index'
    end
  end
end
