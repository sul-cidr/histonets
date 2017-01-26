/* globals $, Range, Select */

class ToggleForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = { value: props.value, enabled: false };

    this.handleOptionChange = this.handleOptionChange.bind(this);
    this.onUpdate = this.onUpdate.bind(this);

    this.acceptableComponents = {
      Range,
      Select,
    };
  }

  componentDidMount() {
    this.attachTooltip();
  }

  componentDidUpdate() {
    this.attachTooltip();
  }

  onUpdate(value) {
    this.setState({ value });
  }

  handleOptionChange() {
    const newState = !(this.state.enabled);
    this.setState({ enabled: newState });
    this.props.handleEnableChange(newState);
  }

  attachTooltip() {
    $(this.tooltip).tooltip();
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

  componentBasedOnType() {
    const thisComponent = this.acceptableComponents[this.props.formType];
    return React.createElement(thisComponent, {
      ...this.props,
      enabled: this.state.enabled,
      onUpdate: this.onUpdate,
      customLabel: this.customLabel(),
      fieldName: this.fieldName(),
    });
  }

  render() {
    return (
      <div className="form-group row">
        <label
          className="col-sm-2 form-text text-capitalize"
          data-toggle="tooltip"
          data-title={this.props.helpText}
          htmlFor={this.customLabel()}
          ref={(tooltip) => { this.tooltip = tooltip; }}
        >
          {this.props.type}
        </label>
        <div className="col-sm-4">
          {this.componentBasedOnType()}
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

ToggleForm.propTypes = {
  object: React.PropTypes.string.isRequired,
  attribute: React.PropTypes.string.isRequired,
  type: React.PropTypes.string.isRequired,
  value: React.PropTypes.number,
  handleEnableChange: React.PropTypes.func,
  helpText: React.PropTypes.string,
  formType: React.PropTypes.oneOf(['Range', 'Select']),
};

ToggleForm.defaultProps = {
  handleEnableChange: () => {},
  helpText: '',
  formType: 'Range',
};
