/* global L */

const mapStyle = {
  height: '500px',
  width: '100%',
};

class LeafletIiif extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      iiifLoaded: false,
    };
  }

  componentDidMount() {
    this.createMap();
  }

  createMap() {
    const el = this.leafletContainer;

    const map = L.map(el, {
      center: [0, 0],
      crs: L.CRS.Simple,
      zoom: 0,
    });

    const iiifLayer = L.tileLayer.iiif(this.props.iiifImage);

    map.addLayer(iiifLayer);

    this.setState({ map });

    iiifLayer.on('load', () => {
      this.setState({ iiifLoaded: true });
    });
  }

  render() {
    // Eslint only likes "pure functions" so this is required ¯\_(ツ)_/¯
    if (!this.props.iiifImage) {
      return null;
    }
    return (
      <div id="map" ref={(c) => { this.leafletContainer = c; }} style={mapStyle} />
    );
  }
}

LeafletIiif.propTypes = {
  iiifImage: React.PropTypes.string.isRequired,
};
