# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

##
# Job for processing an Image from a CollectionTemplate
class ProcessImageJob < ApplicationJob
  queue_as :default
  include TrackableJob

  ##
  # Executes a synchronous set of tasks for Image -> Graph
  # @param [CollectionTemplate] collection_template
  # @param [Image] image
  def perform(collection_template, image)
    clean_image(collection_template, image)
    logger.info "Image #{image.id} is now cleaned!"
    templates = create_templates(collection_template, image)
    logger.info(templates)
    create_image_paths(collection_template, image)
    logger.info 'Image paths created'
  end

  def clean_image(collection_template, image)
    if collection_template.auto_clean
      HistonetsCv::Cli.new(image.file_name)
                      .enhance(
                        "#{collection_template.id}_imageclean",
                        image.full_image_path
                      )
    else
      HistonetsCv::Cli.new(image.file_name)
                      .pipeline(
                        collection_template.image_clean_to_formal_json,
                        image.full_image_path,
                        "#{collection_template.id}_imageclean"
                      )
    end
  end

  # rubocop:disable Metrics/LineLength
  def create_templates(collection_template, image)
    temp = HistonetsCv::Cli.new(image.file_name)
                           .match(
                             collection_template.image_templates
                              .map(&:cli_options).join(' '),
                             "#{Settings.HOST_URL}"\
                             "#{Riiif::Engine.routes.url_helpers.image_path(
                               image.file_name_no_extension +
                                 "_#{collection_template.id}_imageclean_tmp",
                               size: 'full',
                               format: Settings.DEFAULT_IMAGE_EXTENSION
                             )}"
                           )
    JSON.parse(temp)
  end
  # rubocop:enable Metrics/LineLength

  def create_image_paths(collection_template, image)
    HistonetsCv::Cli.new(image.file_name)
                    .select(
                      collection_template.formatted_image_paths,
                      "#{collection_template.id}_imagepaths",
                      "#{Settings.HOST_URL}"\
                      "#{Riiif::Engine.routes.url_helpers.image_path(
                        image.file_name_no_extension +
                          "_#{collection_template.id}_imageclean_tmp",
                        size: 'full',
                        format: Settings.DEFAULT_IMAGE_EXTENSION
                      )}"
                    )
  end
end
# rubocop:enable Metrics/MethodLength
