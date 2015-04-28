class Ckeditor::Picture < Ckeditor::Asset
  has_attached_file :data,
                    :url  => ":s3_domain_url",
                    :path => "public/ckeditor_assets/pictures/:id/:style_:basename.:extension",
                    :storage => :fog,
                    :fog_credentials => {
                        provider: 'AWS',
                        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
                        aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
                    },
                    fog_directory: ENV["FOG_DIRECTORY"],
                    :styles => { :content => '800>', :thumb => '118x100#' }

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 2.megabytes
  validates_attachment_content_type :data, :content_type => /\Aimage/

  def url_content
    url(:content)
  end
end
