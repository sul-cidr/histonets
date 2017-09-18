/* eslint react/jsx-no-undef: "off" */
/* global Range */

class Skeletonize extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      modes: props.modes,
      selectedMode: props.selectedMode,
      binarizationMethod: props.binarizationMethod,
      dilation: parseInt(props.dilation, 10),
      invert: props.invert,
    };
    this.handleModeChange = this.handleModeChange.bind(this);
    this.handleBinarizationChange = this.handleBinarizationChange.bind(this);
    this.handleDilationChange = this.handleDilationChange.bind(this);
    this.handleInvertChange = this.handleInvertChange.bind(this);
  }

  handleModeChange(event) {
    this.setState({ selectedMode: event.target.value });
  }

  handleBinarizationChange(event) {
    this.setState({ binarizationMethod: event.target.value });
  }

  handleDilationChange(dilation) {
    this.setState({ dilation: parseInt(dilation, 10) });
  }

  handleInvertChange(event) {
    this.setState({ invert: event.target.value });
  }

  render() {
    if (!this.props) {
      return null;
    }
    return (
      <div>
        <div className="form-group row">
          <label
            className="col-sm-3 form-text text-capitalize"
            data-toggle="tooltip"
            htmlFor="selected_mode"
          >
            Matching Method
          </label>

          <div className="col-sm-6">
            <select
              name="collection_template[skeletonize][method]"
              value={this.state.selectedMode}
              onChange={this.handleModeChange}
              className={'form-control'}
            >
              { this.props.modes.map(
                  mode => <option value={mode.toLowerCase()} key={Math.random()}>{mode}</option>,
                )}
            </select>
          </div>
        </div>
        <div className="form-group row">
          <label
            className="col-sm-3 form-text text-capitalize"
            data-toggle="tooltip"
            htmlFor="binarizationMethod"
          >
            Binarization Method
          </label>
          <div className="col-sm-6">
            <select
              name="collection_template[skeletonize][binarization-method]"
              value={this.state.binarizationMethod}
              onChange={this.handleBinarizationChange}
              className={'form-control'}
            >
              { this.props.binarizationMethods.map(
                  mode => <option value={mode.toLowerCase()} key={Math.random()}>{mode}</option>,
                )}
            </select>
          </div>
        </div>
        <div className="form-group row">
          <label
            className="col-sm-3 form-text text-capitalize"
            data-toggle="tooltip"
            htmlFor="dilation"
          >Dilation
          </label>
          <div className="col-sm-6">
            <Range
              fieldName="collection_template[skeletonize][dilation]"
              value={this.state.dilation}
              enabled
              onUpdate={this.handleDilationChange}
              className="align-middle"
            />
          </div>
          <div className="col-sm-2">
            {this.state.dilation}
          </div>
        </div>
        <div className="form-group row">
          <label
            className="col-sm-3 form-text text-capitalize"
            data-toggle="tooltip"
            htmlFor="invert"
          >
            Invert
          </label>
          <div className="col-sm-6">
            <select
              name="collection_template[skeletonize][invert]"
              value={this.state.invert}
              onChange={this.handleInvertChange}
              className={'form-control'}
            >
              { this.props.invertOptions.map(
                  mode => <option value={mode.toLowerCase()} key={Math.random()}>{mode}</option>,
                )}
            </select>
          </div>
        </div>
      </div>
    );
  }
}

Skeletonize.propTypes = {
  modes: React.PropTypes.arrayOf(React.PropTypes.string),
  binarizationMethod: React.PropTypes.string,
  binarizationMethods: React.PropTypes.arrayOf(React.PropTypes.string),
  selectedMode: React.PropTypes.string,
  dilation: React.PropTypes.string,
  invert: React.PropTypes.string,
  invertOptions: React.PropTypes.arrayOf(React.PropTypes.string),
};

Skeletonize.defaultProps = {
  selectedMode: 'combined',
  dilation: '1',
  binarizationMethod: 'li',
  modes: ['regular', '3d', 'medial', 'combined', 'thin'],
  binarizationMethods: ['sauvola', 'isodata', 'otsu', 'li'],
  invert: 'false',
  invertOptions: ['true', 'false'],
};
