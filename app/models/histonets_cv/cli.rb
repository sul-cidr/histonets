# frozen_string_literal: true

module HistonetsCv
  ##
  # Ruby class to invoke Python cli application
  class Cli
    include ActiveSupport::Benchmarkable

    delegate :logger, to: :Rails

    attr_reader :file_name

    def initialize(file_name = '')
      @file_name = file_name
    end

    def contrast(value)
      execute("contrast #{value} #{input} #{output('contrast')}")
    end

    def help
      execute('--help')
    end

    def version
      execute('--version')
    end

    private

    def execute(command)
      benchmark("Histonet excecuted #{command}") do
        `histonets #{command}`
      end
    end

    def input
      "file://#{Settings.IMAGE_PATH}/#{file_name}"
    end

    def output(action)
      "-o #{Settings.IMAGE_PATH}/"\
      "#{File.basename(file_name, File.extname(file_name))}_#{action}_tmp"\
      "#{File.extname(file_name)}"
    end
  end
end
