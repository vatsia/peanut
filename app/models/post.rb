class Post < ActiveRecord::Base
  has_many :photos

  def to_param
    "#{id} #{header}".parameterize
  end
end
