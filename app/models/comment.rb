class Comment < ApplicationRecord
  # include Visible
  belongs_to :article
  
  belongs_to :user
  # validates :commenter, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end
