/* global L, LeafletIiif, LeafletIiifCropper */

class IiifCropper extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      iiifLoaded: false,
      region: [0, 0, 300, 300],
    };
    this.onLoad = this.onLoad.bind(this);
    this.onRegionChanged = this.onRegionChanged.bind(this);
  }

  // No need to update the component if everything is loaded
  shouldComponentUpdate(nextProps, nextState) {
    if (nextState.iiifLoaded === this.state.iiifLoaded) {
      return false;
    }
    return true;
  }

  onLoad(leafletState) {
    this.setState({ ...leafletState });
  }

  onRegionChanged(region) {
    this.setState({
      region,
    });
  }

  render() {
    // Eslint only likes "pure functions" so this is required ¯\_(ツ)_/¯
    if (!this.props.iiifImage) {
      return null;
    }
    return (
      <div>
        <LeafletIiif {...this.props} onLoad={this.onLoad} />
        {this.state.iiifLoaded ? (
          <LeafletIiifCropper
            {...this.state}
            cropperName={this.props.cropperName}
            onRegionChanged={this.onRegionChanged}
          />
        ) : null }
      </div>
    );
  }
}

IiifCropper.propTypes = {
  iiifImage: React.PropTypes.string.isRequired,
  cropperName: React.PropTypes.string.isRequired,
};
