/* global L */

class LeafletIiifMasker extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      region: props.region,
    };
  }

  componentWillMount() {
    const map = L.map('map', {
      center: [0, 0],
      crs: L.CRS.Simple,
      zoom: 0,
    });

    // Directly add a IIIF tile to the map
    const imageUrl = 'https://stacks.stanford.edu/image/iiif/cv770rd9515%2F0767_23A_SM/0,2048,2048,2048/512,/0/default.jpg'

    // Grab the region from the URL
    const region = imageUrl.match(/(\d*,){3}\d*/)[0].split(',');
    const size = 512;
    const x = parseInt(region[0], 10); // specifying radix to make linter happy
    const y = parseInt(region[1], 10);

    // Set imageBounds based off of the x,y and size
    const imageBounds = [[y + size, x], [y, size + x]];
    map.fitBounds(imageBounds);
    const overlayLayer = L.imageOverlay(imageUrl, imageBounds);

    // Add the overlayLayer to the map.
    map.addLayer(overlayLayer);

    // Initialise the FeatureGroup to store editable layers
    const drawnItems = new L.FeatureGroup();
    map.addLayer(drawnItems);

    // Initialise the draw control and pass it the FeatureGroup of editable layers,
    // only show the rectangle control
    const drawControl = new L.Control.Draw({
      draw: {
        polygon: false,
        marker: false,
        polyline: false,
        circle: false,
      },
      edit: {
        featureGroup: drawnItems,
      },
    });

    map.addControl(drawControl);

    map.on('draw:created', function (e) {
      const type = e.layerType
      const layer = e.layer;

      const geojson = e.layer.toGeoJSON();
      // Log out the geojson
      console.log(geojson);

      // Convert to annotation
      const layerBounds = e.layer.getBounds();
      // console.log(al)
      const layerX = layerBounds.getWest();
      const layerY = layerBounds.getNorth();
      const w = layerBounds.getEast() - x;
      const h = y - layerBounds.getSouth();
      const annoRegion = [layerX, layerY, w, h];
      const anno = `xywh=${annoRegion.join(',')}`;
      console.log(anno);

      // Do whatever else you need to. (save to db, add to map etc)
      map.addLayer(layer);
    });
  }

  componentWillUpdate(nextProps, nextState) {
    if (nextState.region !== this.state.region) {
      this.props.onRegionChanged(nextState.region);
    }
  }

  render() {
    return (
      <input
          value={this.state.region}
          name={this.props.cropperName}
          readOnly
          hidden
      />
    );
  }
}

LeafletIiifMasker.propTypes = {
  cropperName: React.PropTypes.string.isRequired,
  /* iiifImage: React.PropTypes.string.isRequired,*/
  onRegionChanged: React.PropTypes.func,
};

LeafletIiifMasker.defaultProps = {
  onRegionChanged: () => {},
};
