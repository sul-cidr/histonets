# frozen_string_literal: true
require 'open3'
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

    def brightness(value)
      execute("brightness #{value} #{input} #{output('brightness')}")
    end

    def pipeline(actions, image_url = nil, output_hash = '')
      execute("pipeline '#{actions}' #{input(image_url)} "\
        "#{output(output_hash)}")
    end

    def help
      execute('--help')
    end

    def version
      execute('--version')
    end

    private

    def execute(command)
      logger.info("Executing command #{command}")
      benchmark("Histonet excecuted #{command}") do
        stdout, stdeerr, status = Open3.capture3("histonets #{command}")
        unless status.success?
          raise HistonetsCv::Exceptions::CliError, 'Unable to execute command '\
          "histonets \"#{command}\" \n#{stdeerr}"
        end
        stdout
      end
    end

    def input(image_url = nil)
      if image_url.present?
        image_url
      else
        "file://#{Settings.IMAGE_PATH}/#{file_name}"
      end
    end

    def output(hash)
      "-o #{Settings.IMAGE_PATH}/"\
      "#{File.basename(file_name, File.extname(file_name))}_#{hash}_tmp"\
      "#{File.extname(file_name)}"
    end
  end
end
