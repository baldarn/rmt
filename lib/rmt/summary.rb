# frozen_string_literal: true

class RMT::Summary
  attr_accessor :start_exec_time, :end_exec_time, :total_trasferred_files_size, :total_mirrored_repositories, :total_trasferred_files

  def initialize(
    start_exec_time: 0,
    end_exec_time: 0,
    total_trasferred_files_size: 0,
    total_mirrored_repositories: 0,
    total_trasferred_files: 0
    )

    @start_exec_time = start_exec_time
    @end_exec_time = end_exec_time
    @total_trasferred_files_size = total_trasferred_files_size
    @total_mirrored_repositories = total_mirrored_repositories
    @total_trasferred_files = total_trasferred_files
  end

  def pretty_total_mirror_time
    duration = ActiveSupport::Duration.build(end_exec_time - start_exec_time).parts

    "#{duration.fetch(:hours, 0).round(0).to_s.rjust(2, '0')}:"\
      "#{duration.fetch(:minutes, 0).round(0).to_s.rjust(2, '0')}:"\
      "#{duration.fetch(:seconds, 0).round(0).to_s.rjust(2, '0')}"
  end

  def pretty_total_transferred_file_size
    ActiveSupport::NumberHelper.number_to_human_size(total_trasferred_files_size)
  end
end
