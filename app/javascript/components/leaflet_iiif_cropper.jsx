import L from 'leaflet';
import React from 'react';
import PropTypes from 'prop-types';

export default class LeafletIiifCropper extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      region: props.region,
    };
  }

  componentWillMount() {
    const map = this.props.map;
    const iiifLayer = this.props.iiifLayer;

    const areaSelect = L.areaSelect({
      width: 300,
      height: 300,
    });

    areaSelect.addTo(map);

    const currentThis = this;

    areaSelect.on('change', function bar() {
      const bounds = this.getBounds();
      const zoom = map.getZoom();
      const min = map.project(bounds.getSouthWest(), zoom);
      const max = map.project(bounds.getNorthEast(), zoom);
      /* eslint-disable no-underscore-dangle */
      const imageSize = iiifLayer._imageSizes[zoom];
      /* eslint-enable */
      const xRatio = iiifLayer.x / imageSize.x;
      const yRatio = iiifLayer.y / imageSize.y;
      const region = [
        Math.floor(min.x * xRatio),
        Math.floor(max.y * yRatio),
        Math.floor((max.x - min.x) * xRatio),
        Math.floor((min.y - max.y) * yRatio),
      ];

      currentThis.setState({ region });
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

LeafletIiifCropper.propTypes = {
  cropperName: PropTypes.string.isRequired,
  iiifLayer: PropTypes.shape({
    getTileUrl: PropTypes.func.isRequired,
  }).isRequired,
  map: PropTypes.shape({
    getZoom: PropTypes.func.isRequired,
  }).isRequired,
  onRegionChanged: PropTypes.func,
  region: PropTypes.arrayOf(PropTypes.number).isRequired,
};

LeafletIiifCropper.defaultProps = {
  onRegionChanged: () => {},
};
