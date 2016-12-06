var osdCanvas = new OpenSeadragon({
  id: 'osdCanvas',
  preserveViewport: true,
  showNavigationControl: false,
  constrainDuringPan: true,
  tileSources:[window.imageURL]
});

osdCanvas.iiifCrop();

$('.btn').on('click', function(event) {
  var regionField = $('#collection_template_crop_bounds');
  var region = osdCanvas.cropper.getIiifSelection().getRegion();

  regionField.val(region.toString());
});
