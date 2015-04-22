class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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
end
