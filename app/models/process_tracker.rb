# frozen_string_literal: true

##
# ActiveRecord model for the ProcessTracker
class ProcessTracker < ApplicationRecord
  belongs_to :trackable, polymorphic: true
  STATUS_ENQUEUED = 'ENQUEUED'
  STATUS_STARTED = 'STARTED'
  STATUS_COMPLETED = 'COMPLETED'

  validates :status, inclusion: {
    in: [STATUS_ENQUEUED, STATUS_STARTED, STATUS_COMPLETED, nil]
  }

  def enqueued!
    update(status: STATUS_ENQUEUED)
  end

  def enqueued?
    status == STATUS_ENQUEUED
  end

  def started!
    update(status: STATUS_STARTED)
  end

  def started?
    status == STATUS_STARTED
  end

  def completed!
    update(status: STATUS_COMPLETED)
  end

  def completed?
    status == STATUS_COMPLETED
  end
end
