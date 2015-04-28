class Ckeditor::AttachmentFile < Ckeditor::Asset
  has_attached_file :data,
                    :url  => ":s3_domain_url",
                    :path => "public/ckeditor_assets/attachments/:id/:filename",
                    :storage => :fog,
                    :fog_credentials => {
                        provider: 'AWS',
                        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
                        aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
                    },
                    fog_directory: ENV["FOG_DIRECTORY"]

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 100.megabytes
  do_not_validate_attachment_file_type :data

  def url_thumb
    @url_thumb ||= Ckeditor::Utils.filethumb(filename)
  end
end
