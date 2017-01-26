class Select extends React.Component {
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
  customLabel: React.PropTypes.string,
  enabled: React.PropTypes.bool,
  fieldName: React.PropTypes.string,
  options: React.PropTypes.arrayOf(React.PropTypes.string),
};

Select.defaultProps = {
  options: [],
};
