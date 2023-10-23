require 'json'
class Roda
  module RodaPlugins
    module HTMX
      module InstanceMethods
        def hx_request?
          request.headers['HX_REQUEST'] == 'true'
        end

        def hx_render(*args, **opts)
          if hx_request?
            render(*args, **opts)
          else
            view(*args, **opts)
          end
        end

        def hx_redirect(path)
          if hx_request?
            response['hx-redirect'] = path
            response.status = 200
          else
            redirect(path)
          end
        end
      end
    end
    register_plugin(:htmx, HTMX)
  end
end
