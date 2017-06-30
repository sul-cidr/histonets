/* global L */

import React from 'react';
import PropTypes from 'prop-types';

const mapStyle = {
  height: '500px',
  width: '100%',
};

export default class LeafletIiif extends React.Component {
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

    const iiifLayer = L.tileLayer.iiif(this.props.iiifImage, {
      maxZoom: 7,
    });

    map.addLayer(iiifLayer);

    this.setState({ map, iiifLayer });

    iiifLayer.on('load', () => {
      this.setState({ iiifLoaded: true });
      this.props.onLoad(this.state);
    });
  }

  render() {
    // Eslint only likes "pure functions" so this is required ¯\_(ツ)_/¯
    if (!this.props.iiifImage) {
      return null;
    }
    return (
      <div>
        <div id="map" ref={(c) => { this.leafletContainer = c; }} style={mapStyle} />
      </div>
    );
  }
}

LeafletIiif.propTypes = {
  iiifImage: PropTypes.string.isRequired,
  onLoad: PropTypes.func,
};

LeafletIiif.defaultProps = {
  onLoad: () => {},
};
