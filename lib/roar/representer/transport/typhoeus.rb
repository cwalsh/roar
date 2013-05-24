require 'faraday'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

module Roar
  module Representer
    module Transport
      # Advanced implementation of the HTTP verbs with the Faraday HTTP library
      # (which can, in turn, use adapters based on Net::HTTP or libcurl)
      #
      # Depending on how the Faraday middleware stack is configured, this
      # Transport can support features such as HTTP error code handling,
      # redirects, etc.
      #
      # @see http://rubydoc.info/gems/faraday/file/README.md Faraday README
      class Typhoeus

        def get_uri(uri, as)
          with_accept(as) do
            get uri
          end
        end

        def post_uri(uri, body, as)
          with_accept(as) do
            post(uri, body)
          end
        end

        def put_uri(uri, body, as)
          with_accept(as) do
            put(uri, body)
          end
        end

        def patch_uri(uri, body, as)
          with_accept(as) do
            patch(uri, body)
          end
        end

        def delete_uri(uri, as)
          with_accept(as) do
            delete uri
          end
        end

        class << self

          def client
            @@client ||= ::Faraday::Connection.new(
            ) do |builder|
              builder.use ::Faraday::Response::RaiseError
              builder.adapter :typhoeus
            end
          end

        end

      private

        def with_accept(as, &block)
          old_headers=Typhoeus.client.headers
          begin
            Typhoeus.client.headers = old_headers.merge({:accept => as, :content_type => as})
            response = Typhoeus.client.instance_eval &block
          ensure
            Typhoeus.client.headers = old_headers
          end
          response
        end
      end
    end
  end
end
