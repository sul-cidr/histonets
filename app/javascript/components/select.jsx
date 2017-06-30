import React from 'react';
import PropTypes from 'prop-types';

export default class Select extends React.Component {
  render() {
    if (!this.props) {
      return null;
    }
    return (
      <select
        name={this.props.fieldName}
        disabled={!this.props.enabled}
        id={this.props.customLabel}
        className="form-control"
      >
        { this.props.options.map(
          option => <option value={option.toLowerCase()} key={Math.random()}>{option}</option>,
        )}
      </select>
    );
  }
}

Select.propTypes = {
  customLabel: PropTypes.string,
  enabled: PropTypes.bool,
  fieldName: PropTypes.string,
  options: PropTypes.arrayOf(PropTypes.string),
};

Select.defaultProps = {
  options: [],
};
