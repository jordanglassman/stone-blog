class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :post
  # attr_accessible :title, :body
end
