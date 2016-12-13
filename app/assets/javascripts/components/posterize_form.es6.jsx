/* global ToggleSlider, RadioSet */

class PosterizeForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = { enabled: false };
    this.handleEnableChange = this.handleEnableChange.bind(this);
  }

  handleEnableChange(toggleState) {
    this.setState({ enabled: toggleState });
  }

  render() {
    if (!this.props) {
      return null;
    }
    return (
      <div>
        <ToggleSlider
          {...this.props}
          handleEnableChange={this.handleEnableChange}
        />
        <RadioSet enabled={this.state.enabled} />
      </div>
    );
  }
}

PosterizeForm.propTypes = {
};

PosterizeForm.defaultProps = {
};
