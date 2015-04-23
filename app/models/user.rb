class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts, dependent: :destroy

  # methods that make the admins from newbie
  def admin!
    self.rank = 4
    self.save
  end

  def editor!
    self.rank = 3
    self.save
  end

  def author!
    self.rank = 2
    self.save
  end

  def corrector!
    self.rank = 1
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
end
