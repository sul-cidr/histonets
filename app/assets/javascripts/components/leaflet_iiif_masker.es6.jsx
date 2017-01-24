/* global L */

const mapStyle = {
  height: '500px',
  width: '100%',
};

class LeafletIiifMasker extends React.Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    const map = L.map(this.leafletContainer, {
      center: [0, 0],
      crs: L.CRS.Simple,
      zoom: 0,
    });

    // Directly add a IIIF tile to the map

    // Grab the region from the URL
    const region = this.props.iiifImage.match(/(\d*,){3}\d*/)[0].split(',');
    const size = 512;
    const x = parseInt(region[0], 10); // specifying radix to make linter happy
    const y = parseInt(region[1], 10);

    // Set imageBounds based off of the x,y and size
    const imageBounds = [[y + size, x+80], [y+80, size + x]];
    map.fitBounds(imageBounds);
    /* const baseLayer = L.imageOverlay(imageUrl, imageBounds);*/
    const baseLayer = L.imageOverlay(this.props.iiifImage, imageBounds);

    // Add the overlayLayer to the map.
    baseLayer.addTo(map);

    /* Add the overlayLayer to the map.
     * baseLayer.addTo(map);*/

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

    map.on(L.Draw.Event.CREATED, function (e) {
      const layer = e.layer;

      const geojson = e.layer.toGeoJSON();

      // Convert to annotation
      const layerBounds = e.layer.getBounds();
      const layerX = layerBounds.getWest();
      const layerY = layerBounds.getNorth();
      const w = layerBounds.getEast() - x;
      const h = y - layerBounds.getSouth();
      const annoRegion = [layerX, layerY, w, h];
      const anno = `xywh=${annoRegion.join(',')}`;

      // Do whatever else you need to. (save to db, add to map etc)
      drawnItems.addLayer(layer);
    });
  }

  componentWillUpdate(nextProps, nextState) {
    if (nextState.region !== this.state.region) {
      this.props.onRegionChanged(nextState.region);
    }
  }

  render() {
    // Eslint only likes "pure functions" so this is required ¯\_(ツ)_/¯
    return (
      <div>
        <div id="map" ref={(c) => { this.leafletContainer = c; }} style={mapStyle} />
      </div>
    );
  }
}

LeafletIiifMasker.propTypes = {
  iiifImage: React.PropTypes.string.isRequired,
  onRegionChanged: React.PropTypes.func,
};

LeafletIiifMasker.defaultProps = {
  onRegionChanged: () => {},
};
