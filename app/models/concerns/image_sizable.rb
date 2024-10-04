module ImageSizable
  extend ActiveSupport::Concern

  class_methods do
    def has_sizable(*fields, **_options)
      fields.each do |field|
        define_method("#{field}_urls") do |*selected_sizes|
          attachment = send(field)
          return {} unless attachment.attached?

          generate_urls(attachment, *selected_sizes)
        end
      end
    end
  end

  def generate_urls(blob, *selected_sizes)
    selected_sizes = default_sizes if selected_sizes.empty?
    selected_sizes.map!(&:to_s)

    urls = {}
    if blob.image?
      selected_sizes.each do |size|
        if size == 'original'
          urls[size] = Rails.application.routes.url_helpers.rails_blob_url(blob)
        else
          variant = blob.variant(resize_to_limit: size_detail(size))
          urls[size] = Rails.application.routes.url_helpers.rails_representation_url(variant)
        end
      end
    else
      urls['original'] = Rails.application.routes.url_helpers.rails_blob_url(blob)
    end
    urls
  end

  def size_detail(size)
    case size
    when 'small'
      [600, 600]
    when 'medium'
      [1200, 1200]
    when 'large'
      [1920, 1920]
    else
      'original'
    end
  end

  def default_sizes
    @default_sizes ||= %w[
      original
      small
      medium
      large
    ]
  end
end
