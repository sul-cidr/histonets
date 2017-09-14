/* eslint react/jsx-no-undef: "off" */
/* global Range */

class Blobs extends React.Component {
  constructor(props) {
    super(props);
    const enabledBool = props.enabled === 'true';
    this.state = {
      maximumArea: parseInt(props.maximumArea, 10),
      threshold: parseInt(props.threshold, 10),
      connectivity: parseInt(props.connectivity, 10),
      enabled: enabledBool,
    };
    this.handleMinChange = this.handleMinChange.bind(this);
    this.handleThresholdChange = this.handleThresholdChange.bind(this);
    this.handleConnectivityChange = this.handleConnectivityChange.bind(this);
    this.handleEnableChange = this.handleEnableChange.bind(this);
  }

  handleMinChange(maximumArea) {
    this.setState({ maximumArea: parseInt(maximumArea, 10) });
  }

  handleThresholdChange(threshold) {
    this.setState({ threshold: parseInt(threshold, 10) });
  }

  handleConnectivityChange(event) {
    this.setState({ connectivity: event.target.value });
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
              htmlFor="minimum-area"
            >Max
            </label>
            <div className="col-sm-6">
              <Range
                fieldName="collection_template[blobs][maximum-area]"
                value={this.state.maximumArea}
                enabled={this.state.enabled}
                onUpdate={this.handleMinChange}
                className="align-middle"
                max={200}
              />
            </div>
            <div className="col-sm-2">
              {this.state.maximumArea}
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
                fieldName="collection_template[blobs][threshold]"
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
              htmlFor="connectivity"
            >
              Connectivity
            </label>
            <div className="col-sm-6">
              <select
                name="collection_template[blobs][connectivity]"
                value={this.state.connectivity}
                onChange={this.handleConnectivityChange}
                className={'form-control'}
              >
                { this.props.connectivityOptions.map(
                  connectivity =>
                    <option value={connectivity} key={Math.random()}>{connectivity}</option>,
                )}
              </select>
            </div>
          </div>
        </div>
        <div className="col-sm-2">
          <fieldset>
            <label
              className="switch-light switch-material"
              htmlFor="blobs_enabled"
            >
              <input
                value={this.state.enabled}
                name="collection_template[enabled_options][blobs]"
                readOnly
                hidden
              />
              <input
                id="blobs_enabled"
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

Blobs.propTypes = {
  maximumArea: React.PropTypes.string,
  threshold: React.PropTypes.string,
  connectivity: React.PropTypes.string,
  connectivityOptions: React.PropTypes.arrayOf(React.PropTypes.string),
  enabled: React.PropTypes.string,
};

Blobs.defaultProps = {
  maximumArea: '100',
  threshold: '128',
  connectivity: '8',
  connectivityOptions: ['4', '8', '16'],
  enabled: 'false',
};
