# frozen_string_literal: true

##
# Translator class for turning CollectionTemplates into IIIF manifests
class ManifestPresenter
  attr_reader :collection_template, :image_info
  attr_accessor :canvas, :sequence
  delegate :id, :cleaned_image, :image_matches, to: :collection_template

  ##
  # @param [CollectionTemplate]
  def initialize(collection_template)
    @collection_template = collection_template
    @image_info = Riiif::Image.new(cleaned_image).info
    @sequence = IIIF::Presentation::Sequence.new
    @canvas = IIIF::Presentation::Canvas.new(
      '@id' => path,
      'label' => 'canvas',
      'width' => image_info[:width],
      'height' => image_info[:height]
    )
  end

  ##
  # So this is #complicated, due to the complicated nature of the IIIF
  # Presentation API and the OSullivan API
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def manifest
    anno = IIIF::Presentation::Annotation.new('on' => path)
    anno.resource = create_resource
    canvas.images << anno
    canvas.other_content = [annotations]
    manifest = IIIF::Presentation::Manifest.new(
      '@id' => path,
      'label' => "Histonets - Collection Template #{id}"
    )
    sequence.canvases << canvas
    manifest.sequences << sequence
    manifest
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def annotations
    anno_list = IIIF::Presentation::AnnotationList.new(
      '@context' => 'http://iiif.io/api/presentation/2/context.json',
      '@id' => annotations_url
    )
    anno_list.resources = matches_to_resources
    anno_list
  end

  private

  def matches_to_resources
    image_matches.map.with_index do |match, i|
      IIIF::Presentation::Resource.new(
        '@id' => "#{i}#xywh=#{Bounds.from_array(match).to_xywh}",
        '@type' => 'oa:Annotation',
        'motivation' => 'sc:painting',
        'resource' => template_match,
        'on' => "#{path}#xywh=#{Bounds.from_array(match).to_xywh}"
      )
    end
  end

  def template_match
    {
      '@id' => SecureRandom.hex,
      '@type' => 'cnt:ContentAsText',
      'format' => 'text/plain',
      'chars' => 'Image Template Match'
    }
  end

  def create_resource
    IIIF::Presentation::ImageResource.create_image_api_image_resource(
      '@id' => cleaned_image_service_base,
      'label' => "Image #{id}",
      service_id: cleaned_image_service_base,
      resource_id: cleaned_image_service_base,
      width: image_info[:width],
      height: image_info[:height],
      profile: 'http://iiif.io/api/image/2/profiles/level2.json'
    )
  end

  def url_helpers
    Rails.application.routes.url_helpers
  end

  def cleaned_image_service
    Settings.HOST_URL +
      Riiif::Engine.routes.url_helpers.info_path(cleaned_image)
  end

  def cleaned_image_service_base
    cleaned_image_service.gsub('info.json', '')
  end

  def path
    Settings.HOST_URL + url_helpers.collection_template_path(id)
  end

  def annotations_url
    Settings.HOST_URL + url_helpers.collection_template_annotations_path(id)
  end
end
