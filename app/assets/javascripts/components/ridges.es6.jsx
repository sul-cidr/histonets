/* eslint react/jsx-no-undef: "off" */
/* global Range */

class Ridges extends React.Component {
  constructor(props) {
    super(props);
    const enabledBool = props.enabled === 'true';
    this.state = {
      width: parseInt(props.width, 10),
      threshold: parseInt(props.threshold, 10),
      dilation: parseInt(props.dilation, 10),
      enabled: enabledBool,
    };
    this.handleWidthChange = this.handleWidthChange.bind(this);
    this.handleThresholdChange = this.handleThresholdChange.bind(this);
    this.handleDilationChange = this.handleDilationChange.bind(this);
    this.handleEnableChange = this.handleEnableChange.bind(this);
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

  handleEnableChange() {
    const newState = !(this.state.enabled);
    this.setState({ enabled: newState });
  }

  render() {
    if (!this.props) {
      return null;
    }
    return (
      <div className="row">
        <div className="col-sm-10">
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
                enabled={this.state.enabled}
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
                enabled={this.state.enabled}
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
                enabled={this.state.enabled}
                onUpdate={this.handleDilationChange}
                className="align-middle"
              />
            </div>
            <div className="col-sm-2">
              {this.state.dilation}
            </div>
          </div>
        </div>
        <div className="col-sm-2">
          <fieldset>
            <label
              className="switch-light switch-material"
              htmlFor="ridges_enabled"
            >
              <input
                value={this.state.enabled}
                name="collection_template[enabled_options][ridges]"
                readOnly
                hidden
              />
              <input
                id="ridges_enabled"
                type="checkbox"
                checked={this.state.enabled}
                onChange={this.handleEnableChange}
              />
              <strong>
                Enabled
              </strong>
              <span>
                <span>Off</span>
                <span>On</span>
                <a><span /></a>
              </span>
            </label>
          </fieldset>
        </div>
      </div>
    );
  }
}

Ridges.propTypes = {
  width: React.PropTypes.string,
  threshold: React.PropTypes.string,
  dilation: React.PropTypes.string,
  enabled: React.PropTypes.string,
};

Ridges.defaultProps = {
  width: '10',
  threshold: '128',
  dilation: '0',
  enabled: 'false',
};
