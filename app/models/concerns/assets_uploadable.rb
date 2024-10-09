module AssetsUploadable
  extend ActiveSupport::Concern

  class_methods do
    def has_uploadable(*fields, **_options)
      fields.each do |field|
        attr_accessor "#{field}_blob_id"

        after_save do
          blob_id = send("#{field}_blob_id")
          if blob_id.present?
            blob = ActiveStorage::Blob.find_signed(blob_id)
            send("#{field}_blob_id=", nil)
            send(field).attach(blob)
          end
        end
      end
    end
  end
end
