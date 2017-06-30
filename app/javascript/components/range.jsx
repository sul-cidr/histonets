import React from 'react';
import PropTypes from 'prop-types';

export default class Range extends React.Component {
  constructor(props) {
    super(props);
    this.state = { value: props.value, enabled: false };

    this.handleSliderChange = this.handleSliderChange.bind(this);
  }

  handleSliderChange(event) {
    this.setState({ value: event.target.value }, () => {
      this.props.onUpdate(this.state.value);
    });
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
        className={this.props.className}
      />
    );
  }
}

Range.propTypes = {
  min: PropTypes.number,
  max: PropTypes.number,
  value: PropTypes.number,
  fieldName: PropTypes.string,
  customLabel: PropTypes.string,
  enabled: PropTypes.bool,
  onUpdate: PropTypes.func,
  className: PropTypes.string,
};

Range.defaultProps = {
  min: 0,
  max: 100,
  value: 0,
  onUpdate: () => {},
  className: '',
};
