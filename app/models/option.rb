class Option < ActiveRecord::Base

  def self.set_value(name, value)
    option = where(name: name).first_or_create
    option.value = value

    option.save
  end

  def self.get_value(name)
    option = find_by_name(name)
    return option.value unless option.nil?
    nil
  end
end
