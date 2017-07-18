/* eslint react/jsx-no-undef: "off" */
/* global Range */

class Ridges extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      width: parseInt(this.props.width, 10),
      threshold: parseInt(this.props.threshold, 10),
      dilation: parseInt(props.dilation, 10),
    };
    this.handleWidthChange = this.handleWidthChange.bind(this);
    this.handleThresholdChange = this.handleThresholdChange.bind(this);
    this.handleDilationChange = this.handleDilationChange.bind(this);
  }

  handleWidthChange(width) {
    this.setState({ width: parseInt(width, 10) });
  }

  handleThresholdChange(threshold) {
    this.setState({ threshold: parseInt(threshold, 10) });
  }

  handleDilationChange(dilation) {
    this.setState({ dilation: parseInt(dilation, 10) });
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
            htmlFor="width"
          >Width
          </label>
          <div className="col-sm-6">
            <Range
              fieldName="collection_template[ridges][width]"
              value={this.state.width}
              enabled
              onUpdate={this.handleWidthChange}
              className="align-middle"
              min={1}
            />
          </div>
          <div className="col-sm-2">
            {this.state.width}
          </div>
        </div>
        <div className="form-group row">
          <label
            className="col-sm-3 form-text text-capitalize"
            data-toggle="tooltip"
            htmlFor="threshold"
          >Threshold
          </label>
          <div className="col-sm-6">
            <Range
              fieldName="collection_template[ridges][threshold]"
              value={this.state.threshold}
              enabled
              onUpdate={this.handleThresholdChange}
              className="align-middle"
              max={255}
            />
          </div>
          <div className="col-sm-2">
            {this.state.threshold}
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
              fieldName="collection_template[ridges][dilation]"
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
      </div>
    );
  }
}

Ridges.propTypes = {
  width: React.PropTypes.string,
  threshold: React.PropTypes.string,
  dilation: React.PropTypes.string,
};

Ridges.defaultProps = {
  width: '6',
  threshold: '128',
  dilation: '3',
};
