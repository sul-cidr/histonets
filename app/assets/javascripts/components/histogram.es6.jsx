class Histogram extends React.Component {
  histogramToColor() {
    return `rgb${this.props.histogram[0]}`;
  }

  render() {
    return (
      <li>
        <div>
          <span
            className="histogram-color d-inline-block"
            style={{
              backgroundColor: this.histogramToColor(),
            }}
          />
          Count: {this.props.histogram[1]}
        </div>
      </li>
    );
  }
}

Histogram.propTypes = {
  histogram: React.PropTypes.arrayOf(
    React.PropTypes.string,
  ),
};
