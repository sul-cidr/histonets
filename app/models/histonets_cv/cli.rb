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

    def match(image_templates, image_url = nil)
      execute("match #{image_templates} #{input(image_url)}")
    end

    def select(image_paths, additional_file_name, image_url = nil)
      execute("select #{image_paths} #{input(image_url)} "\
        "#{output(additional_file_name)}")
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
        "#{Settings.IMAGE_PATH}/#{file_name}"
      end
    end

    ##
    # @param [String] additional_file_name often times could just be the
    # fingerprint
    def output(additional_file_name)
      "-o #{Settings.IMAGE_PATH}/"\
      "#{File.basename(file_name, File.extname(file_name))}_"\
      "#{additional_file_name}_tmp"\
      ".#{extension}"
    end
  end
end
