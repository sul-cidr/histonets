class ToggleSlider extends React.Component {
  constructor(props) {
    super(props);
    this.state = { value: props.value, enabled: false };

    this.handleSliderChange = this.handleSliderChange.bind(this);
    this.handleOptionChange = this.handleOptionChange.bind(this);
  }

  handleSliderChange(event) {
    this.setState({ value: event.target.value });
  }

  handleOptionChange() {
    this.setState({ enabled: !(this.state.enabled) });
  }

  fieldName() {
    if (this.state.enabled) {
      return `${this.props.object}[${this.props.attribute}][${this.props.type}]`;
    }
    /*
     * We don't want to send through form elements that are disabled, so set a
     * bad name here
    */
    return '';
  }

  customLabel() {
    return `${this.props.object}_${this.props.attribute}_${this.props.type}`;
  }

  render() {
    return (
      <div className="form-group row">
        <p className="col-sm-2 form-text text-capitalize">{this.props.type}</p>
        <div className="col-sm-4">
          <input
            min={this.props.min}
            max={this.props.max}
            type="range"
            name={this.fieldName()}
            id={this.customLabel()}
            onChange={this.handleSliderChange}
            disabled={!this.state.enabled}
            style={{ width: '100%' }}
            value={this.state.value}
          />
        </div>
        <div className="col-sm-2">
          {this.state.value}
        </div>
        <div className="col-sm-2">
          <fieldset>
            <label className="switch-light switch-material" htmlFor={`${this.customLabel()}_enabled`}>
              <input
                id={`${this.customLabel()}_enabled`}
                type="checkbox"
                value={false}
                checked={this.state.enabled}
                onChange={this.handleOptionChange}
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

ToggleSlider.propTypes = {
  min: React.PropTypes.number,
  max: React.PropTypes.number,
  object: React.PropTypes.string.isRequired,
  attribute: React.PropTypes.string.isRequired,
  type: React.PropTypes.string.isRequired,
  value: React.PropTypes.number,
};

ToggleSlider.defaultProps = {
  min: 0,
  max: 100,
  value: 0,
};
