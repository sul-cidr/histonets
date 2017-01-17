class RadioSet extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      selectedOption: props.defaultRadio,
      enabled: props.enabled,
    };
    this.handleOptionChange = this.handleOptionChange.bind(this);
  }

  handleOptionChange(changeEvent) {
    this.setState({
      selectedOption: changeEvent.target.value,
    });
  }

  fieldName() {
    if (this.props.enabled) {
      return 'collection_template[image_clean][posterize_method]';
    }
    /*
     * We don't want to send through form elements that are disabled, so set a
     * bad name here
    */
    return '';
  }

  labelClasses() {
    const buttonClasses = 'btn btn-primary';
    if (!this.props.enabled) {
      return `${buttonClasses} disabled`;
    }
    return buttonClasses;
  }

  activeClasses() {
    return `${this.labelClasses()} active`;
  }

  render() {
    return (
      <div className="form-group row">
        <div className="col-sm-2">
          <p>Method</p>
        </div>
        <div className="col-sm-4">
          <div
            className="btn-group"
            disabled={!this.props.enabled}
            data-toggle="buttons"
          >
            <label htmlFor={this.props.formName} className={this.activeClasses()}>
              <input
                type="radio"
                value={this.props.defaultRadio}
                name={this.fieldName()}
                checked={this.state.selectedOption === this.props.defaultRadio}
                onChange={this.handleOptionChange}
              />
              {this.props.defaultRadio}
            </label>
            <label htmlFor={this.props.formName} className={this.labelClasses()}>
              <input
                type="radio"
                value={this.props.otherRadio}
                name={this.fieldName()}
                checked={this.state.selectedOption === this.props.otherRadio}
                onChange={this.handleOptionChange}
              />
              {this.props.otherRadio}
            </label>
          </div>
        </div>
      </div>
    );
  }
}

RadioSet.propTypes = {
  defaultRadio: React.PropTypes.string,
  enabled: React.PropTypes.bool,
  formName: React.PropTypes.string,
  otherRadio: React.PropTypes.string,
};

RadioSet.defaultProps = {
  enabled: false,
};
