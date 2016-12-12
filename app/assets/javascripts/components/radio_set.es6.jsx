class RadioSet extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      selectedOption: 'kmeans',
    };
    this.handleOptionChange = this.handleOptionChange(this);
  }

  handleOptionChange(changeEvent) {
    this.setState({
      selectedOption: changeEvent.target.value,
    });
  }

  render() {
    return (
      <div className="form-group row">
        <div className="col-sm-2">
          <p>Method</p>
        </div>
        <div className="col-sm-4">
          <fieldset>
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
  checked: React.PropTypes.string,
};

RadioSet.defaultProps = {
  checked: 'kmeans',
};
