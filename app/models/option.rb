class Option < ActiveRecord::Base

  def self.set_value(name, value)
    option = where(name: name).first_or_create
    option.value = value

    option.save
  end

  def self.get_value(name)
    find_by_name(name).value
  end
end
