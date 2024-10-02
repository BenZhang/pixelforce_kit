# frozen_string_literal: true

def load_swagger_schemas(components_dir)
  schemas = {}

  Dir.glob(File.join(components_dir, '*.yml')).each do |file|
    if File.exist?(file)
      schemas.merge!(YAML.load_file(file))
    else
      puts "Warning: #{file} not found"
    end
  end

  schemas
end

# rake rswag:specs:swaggerize PATTERN="{spec/integration,vendor/**/integration}/**/*_spec.rb"

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.exclude_pattern = ''
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi:    '3.0.1',
      info:       {
        title:   'API V1',
        version: 'v1'
      },
      paths:      {},
      components: {
        schemas:         load_swagger_schemas(Rails.root.join('swagger', 'components')),
        securitySchemes: {
          accessToken: {
            type: :apiKey,
            in:   :header,
            name: 'access-token'
          },
          tokenType:   {
            type: :apiKey,
            in:   :header,
            name: 'token-type'
          },
          client:      {
            type: :apiKey,
            in:   :header,
            name: 'client'
          },
          expiry:      {
            type: :apiKey,
            in:   :header,
            name: 'expiry'
          },
          uid:         {
            type: :apiKey,
            in:   :header,
            name: 'uid'
          }
        }
      },
      servers:    [
        {
          url:       '{http}://{defaultHost}/{base_path}/',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            },
            base_path:   {
              default: 'api/v1'
            },
            http:        {
              default: 'http'
            }
          }
        }
      ]
    },
    'v1/swagger_admin.yaml' => {
      openapi:    '3.0.1',
      info:       {
        title:   'Admin API V1',
        version: 'v1'
      },
      paths:      {},
      components: {
        schemas:         load_swagger_schemas(Rails.root.join('swagger', 'components')),
        securitySchemes: {
          accessToken: {
            type: :apiKey,
            in:   :header,
            name: 'access-token'
          },
          tokenType:   {
            type: :apiKey,
            in:   :header,
            name: 'token-type'
          },
          client:      {
            type: :apiKey,
            in:   :header,
            name: 'client'
          },
          expiry:      {
            type: :apiKey,
            in:   :header,
            name: 'expiry'
          },
          uid:         {
            type: :apiKey,
            in:   :header,
            name: 'uid'
          }
        }
      },
      servers:    [
        {
          url:       '{http}://{defaultHost}/{base_path}/',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            },
            base_path:   {
              default: 'admin/api'
            },
            http:        {
              default: 'http'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
