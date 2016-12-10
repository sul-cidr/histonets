const cropperStyle = {
  height: '500px',
  width: '100%',
};

class CropImage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      region: this.props.region || [0, 0, 300, 300],
      imagePath: this.props.imagePath || null
    };
    this.submitRegion = this.submitRegion.bind(this);
  }

  componentDidMount() {
    this.osdCanvas = new OpenSeadragon({
      id: 'osdCanvas',
      preserveViewport: true,
      showNavigationControl: false,
      constrainDuringPan: true,
      tileSources: [this.props.imagePath],
    });

    this.osdCanvas.iiifCrop();
  }

  submitRegion(event) {
    this.setState({ region: this.osdCanvas.cropper.getIiifSelection().getRegion() });
  }

  render() {
    // Ensure return value
    if (!this.props.imagePath) {
      return null;
    }
    // onClick is used below instead of onSubmit
    // in order to trick turbolinks, which seems
    // to run its own submit handler first.
    return (
      <div>
        <div className="form-group">
          <div id="osdCanvas" style={cropperStyle} />
          <input type="text" value={this.state.region} name="collection_template[crop_bounds]" id="collection_template_crop_bounds" />
        </div>
        <input onClick={this.submitRegion} type="submit" name="commit" value="Next Step" className="btn btn-primary" data-disable-with="Next Step" />
      </div>
    );
  }
}

CropImage.propTypes = {
  imagePath: React.PropTypes.string.isRequired,
  region: React.PropTypes.array.isRequired,
};
