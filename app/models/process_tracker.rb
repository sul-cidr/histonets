# frozen_string_literal: true

##
# ActiveRecord model for the ProcessTracker
class ProcessTracker < ApplicationRecord
  belongs_to :trackable, polymorphic: true
end
