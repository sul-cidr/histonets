import React from 'react';
import ToggleForm from './toggle_form';
import RadioSet from './radio_set';

export default class PosterizeForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      enabled: false,
      formName: 'posterize_method',
      defaultRadio: 'kmeans',
      otherRadio: 'linear',
    };
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
        <ToggleForm
          {...this.props}
          handleEnableChange={this.handleEnableChange}
        />
        <RadioSet
          enabled={this.state.enabled}
          formName={this.state.formName}
          defaultRadio={this.state.defaultRadio}
          otherRadio={this.state.otherRadio}
        />
      </div>
    );
  }
}

PosterizeForm.propTypes = {
};

PosterizeForm.defaultProps = {
};
