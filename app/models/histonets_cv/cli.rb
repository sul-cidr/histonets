# frozen_string_literal: true
require 'open3'
module HistonetsCv
  ##
  # Ruby class to invoke Python cli application
  class Cli
    include ActiveSupport::Benchmarkable

    delegate :logger, to: :Rails

    attr_reader :file_name, :extension

    def initialize(file_name = '', extension = 'png')
      @file_name = file_name
      @extension = extension
    end

    def contrast(value)
      execute("contrast #{value} #{input} #{output('contrast')}")
    end

    def brightness(value)
      execute("brightness #{value} #{input} #{output('brightness')}")
    end

    ##
    # @param [String] actions a conforming Histonets JSON string
    # @param [String] image_url url to an image to process
    # @param [String] fingerprint
    def pipeline(actions, image_url = nil, fingerprint = '')
      execute("pipeline '#{actions}' #{input(image_url)} "\
        "#{output(fingerprint)}")
    end

    ##
    # @param [String] fingerprint
    # @param [String] image_url url to an image to process
    def enhance(fingerprint, image_url = nil)
      execute("enhance #{input(image_url)} #{output(fingerprint)}")
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

    ##
    # @param [String] image_url input image_url
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
      ".#{extension}"
    end
  end
end
