class FlipForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = { value: props.value, enabled: false };

    this.handleOptionChange = this.handleOptionChange.bind(this);
  }

  handleOptionChange() {
    const newState = !(this.state.enabled);
    this.setState({ enabled: newState });
    this.props.handleEnableChange(newState);
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
          <select
            name={this.fieldName()}
            disabled={!this.state.enabled}
            id={this.customLabel()}
            className="form-control"
          >
            <option value="horizontal">Horizontal</option>
            <option value="vertical">Vertical</option>
            <option value="both">Both</option>
          </select>
        </div>
        <div className="col-sm-2" />
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

FlipForm.propTypes = {
  object: React.PropTypes.string.isRequired,
  attribute: React.PropTypes.string.isRequired,
  type: React.PropTypes.string.isRequired,
  value: React.PropTypes.number,
  handleEnableChange: React.PropTypes.func,
};

FlipForm.defaultProps = {
  min: 0,
  max: 100,
  value: 0,
  handleEnableChange: () => {},
};
