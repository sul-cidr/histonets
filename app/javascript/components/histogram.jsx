import React from 'react';
import PropTypes from 'prop-types';

export default class Histogram extends React.Component {
  // Tried to push some of this into a seperate es6 model, but PhantomJS would
  // not comply. :(
  static formattedColor(color) {
    return color.replace(/(\(|\))/g, '').split(',').map(n => (parseInt(n, 10)));
  }

  constructor(props) {
    super(props);

    let currentlyEnabled = false;

    // Contains is not available in PhantomJS and our tests will not work.
    if (props.imagePaths.indexOf(Histogram.formattedColor(props.histogram[0]).join(',')) !== -1) {
      currentlyEnabled = true;
    }

    this.state = {
      enabled: currentlyEnabled,
    };

    this.handleHistogramChange = this.handleHistogramChange.bind(this);
  }

  handleHistogramChange() {
    const enabled = !(this.state.enabled);
    this.setState({ enabled });
  }

  render() {
    let hiddenFormInput = null;
    if (this.state.enabled) {
      hiddenFormInput = (
        <input
          type="text"
          hidden
          name={this.props.pathName}
          readOnly
          value={Histogram.formattedColor(this.props.histogram[0])}
        />
      );
    }

    return (
      <li className="media">
        <div className="form-check">
          {hiddenFormInput}
          <label className="form-check-label" htmlFor={this.props.histogram.color}>
            <input
              type="checkbox"
              className="form-check-input"
              checked={this.state.enabled}
              onChange={this.handleHistogramChange}
            />
            <span
              className="histogram-color d-flex mr-3"
              style={{
                backgroundColor: `rgb${this.props.histogram[0]}`,
              }}
            />
            <div className="media-body">
              Count: {parseInt(this.props.histogram[1], 10).toLocaleString()}
            </div>
          </label>
        </div>
      </li>
    );
  }
}

Histogram.propTypes = {
  histogram: PropTypes.arrayOf(
    PropTypes.string,
  ),
  pathName: PropTypes.string.isRequired,
  imagePaths: PropTypes.arrayOf(
    PropTypes.string,
  ),
};

Histogram.defaultProps = {
  imagePaths: [],
};
