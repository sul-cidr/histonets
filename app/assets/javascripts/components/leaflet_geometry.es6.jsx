/* global L */

class LeafletGeometry extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      features: new L.FeatureGroup(),
    };
  }

  componentWillMount() {
    const currentThis = this;
    const map = currentThis.props.map;
    map.addLayer(this.state.features);

    currentThis.props.matches.forEach((match) => {
      const bounds = L.bounds(match);
      const min = map.unproject(bounds.min, currentThis.props.unprojectZoom);
      const max = map.unproject(bounds.max, currentThis.props.unprojectZoom);
      currentThis.state.features.addLayer(L.rectangle(L.latLngBounds(min, max)));
    });
  }

  render() {
    return <data data-matches-geometry />;
  }
}

LeafletGeometry.propTypes = {
  matches: React.PropTypes.arrayOf(
    React.PropTypes.array,
  ),
  unprojectZoom: React.PropTypes.number,
};
