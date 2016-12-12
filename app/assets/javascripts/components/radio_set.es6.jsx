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

  render() {
    return (
      <div className="form-group row">
        <div className="col-sm-2">
          <p>Method</p>
        </div>
        <div className="col-sm-4">
          <fieldset
            disabled={!this.props.enabled}
          >
            <label htmlFor="posterize_method">
              <input
                type="radio"
                value="kmeans"
                checked={this.state.selectedOption === 'kmeans'}
                onChange={this.handleOptionChange}
              />
              Kmeans
            </label>
            <label htmlFor="posterize_method">
              <input
                type="radio"
                value="linear"
                checked={this.state.selectedOption === 'linear'}
                onChange={this.handleOptionChange}
              />
              Linear
            </label>
          </fieldset>
        </div>
      </div>
    );
  }
}

RadioSet.propTypes = {
  enabled: React.PropTypes.boolean,
};

RadioSet.defaultProps = {
  enabled: false,
};
