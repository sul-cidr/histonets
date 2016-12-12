class PosterizeForm extends React.Component {
  render () {
    if (!this.props) {
      return;
    }
    return (
      <div>
        <ToggleSlider
          {...this.props}
          ref={(toggleSlider) => { this.state = toggleSlider; }}
        />
        <RadioSet enabled={this.refs.toggleSlider}/>
      </div>
    )
  }
}

PosterizeForm.propTypes = {
};
