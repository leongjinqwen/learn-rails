module Visible
  extend ActiveSupport::Concern

  VALID_STATUSES = ['public', 'private', 'archived']

  included do
    validates :status, in: VALID_STATUSES
  end

  # add class method to concern to use in view(html)
  class_methods do
    # get count of public articles or comments to display on our main page
    def public_count
      where(status: 'public').count
    end
  end

  def archived?
    status == 'archived'
  end
end