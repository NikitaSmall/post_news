class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts, dependent: :destroy

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png",
                    :url  => ":s3_domain_url",
                    :path => "public/avatars/:id/:style_:basename.:extension",
                    :storage => :fog,
                    :fog_credentials => {
                        provider: 'AWS',
                        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
                        aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
                    },
                    fog_directory: ENV["FOG_DIRECTORY"]

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates :username, :email, uniqueness: true
  validates :username, :email, presence: true
  validates :username, length: { in: 3..50 }

  after_create :check_last_stand
  before_destroy :check_for_admin

  # methods that make the admins from newbie
  def admin!
    self.rank = 4
    self.save
  end

  def editor!
    self.rank = 3 unless admin_alone?
    self.save
  end

  def author!
    self.rank = 2 unless admin_alone?
    self.save
  end

  def corrector!
    self.rank = 1 unless admin_alone?
    self.save
  end

  # methods that check the user status
  def newbie?
    rank == 0
  end

  def admin?
    rank == 4
  end

  def editor?
    rank == 3
  end

  def author?
    rank == 2
  end

  def corrector?
    rank == 1
  end

  def check_last_stand
    if alone_or_no_admin?
      admin!
    end
  end

  def alone_or_no_admin?
    return true if (User.count == 1 && User.all.first == self) || User.where(rank: 4).count == 0
    false
  end

  def admin_alone?
    return true if User.where(rank: 4).count == 1 && admin?
    false
  end

  protected
  def check_for_admin
    !admin?
  end
end
