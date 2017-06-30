import React from 'react';
import PropTypes from 'prop-types';
import IiifCropper from './iiif_cropper';

export default class ImageTemplateCropper extends React.Component {
  addTemplate() {
    this.props.onAddNewTemplate(this.cropper.state);
  }
  render() {
    if (!this.props) {
      return null;
    }
    return (
      <div>
        <IiifCropper
          {...this.props}
          ref={(c) => { this.cropper = c; }}
        />
        <button
          className="btn btn-primary"
          onClick={() => { this.addTemplate(); }}
          type="button"
        >
          Add template of cropped area
        </button>
      </div>
    );
  }
}

ImageTemplateCropper.propTypes = {
  onAddNewTemplate: PropTypes.func,
};
