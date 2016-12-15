class RadioSet extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      selectedOption: 'kmeans',
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
            <label htmlFor="posterize_method" className={this.activeClasses()}>
              <input
                type="radio"
                value="kmeans"
                name={this.fieldName()}
                checked={this.state.selectedOption === 'kmeans'}
                onChange={this.handleOptionChange}
              />
              Kmeans
            </label>
            <label htmlFor="posterize_method" className={this.labelClasses()}>
              <input
                type="radio"
                value="linear"
                name={this.fieldName()}
                checked={this.state.selectedOption === 'linear'}
                onChange={this.handleOptionChange}
              />
              Linear
            </label>
          </div>
        </div>
      </div>
    );
  }
}

RadioSet.propTypes = {
  enabled: React.PropTypes.bool,
};

RadioSet.defaultProps = {
  enabled: false,
};
