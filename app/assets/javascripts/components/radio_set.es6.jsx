class RadioSet extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      selectedOption: 'kmeans',
      enabled: props.enabled,
    };
    this.handleOptionChange = this.handleOptionChange.bind(this);
  }

  handlechange = (value) => {
    this.setState({ value });
  };

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
                checked={this.state.selectedOption === 'kmeans'}
                onChange={this.handleOptionChange}
              />
              Kmeans
            </label>
            <label htmlFor="posterize_method" className={this.labelClasses()}>
              <input
                type="radio"
                value="linear"
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
