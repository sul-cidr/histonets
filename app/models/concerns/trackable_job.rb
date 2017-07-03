# frozen_string_literal: true

##
module TrackableJob
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def self.included(base)
    base.class_eval do
      before_enqueue do |job|
        tracker = job_tracker(job.job_id, job.arguments.first)
        tracker.update(status: 'ENQUEUED')
      end

      before_perform do |job|
        tracker = job_tracker(job.job_id, job.arguments.first)
        tracker.update(
          status: 'STARTED',
          job_type: job.class,
          arguments: job.arguments,
          executions: job.executions
        )
      end

      after_perform do |job|
        tracker = job_tracker(job.job_id, job.arguments.first)
        tracker.update(status: 'COMPLETED', executions: job.executions)
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def job_tracker(job_id, trackable)
    @job_tracker ||= ProcessTracker.find_or_create_by(
      job_id: job_id,
      trackable_id: trackable.id,
      trackable_type: trackable.class.name
    )
  end
end
