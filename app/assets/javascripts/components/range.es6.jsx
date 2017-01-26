class Range extends React.Component {
  constructor(props) {
    super(props);
    this.state = { value: props.value, enabled: false };

    this.handleSliderChange = this.handleSliderChange.bind(this);
  }

  handleSliderChange(event) {
    this.setState({ value: event.target.value });
    this.props.onUpdate(this.state.value);
  }

  render() {
    return (
      <input
        min={this.props.min}
        max={this.props.max}
        type="range"
        name={this.props.fieldName}
        id={this.props.customLabel}
        onChange={this.handleSliderChange}
        disabled={!this.props.enabled}
        style={{ width: '100%' }}
        value={this.state.value}
      />
    );
  }
}

Range.propTypes = {
  min: React.PropTypes.number,
  max: React.PropTypes.number,
  value: React.PropTypes.number,
  fieldName: React.PropTypes.string,
  customLabel: React.PropTypes.string,
  enabled: React.PropTypes.bool,
  onUpdate: React.PropTypes.func,
};

Range.defaultProps = {
  min: 0,
  max: 100,
  value: 0,
  onUpdate: () => {},
};
