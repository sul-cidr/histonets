import React from 'react';
import PropTypes from 'prop-types';
import ImageTemplateViewer from './image_template_viewer';

export default class ImageTemplateList extends React.Component {
  constructor(props) {
    super(props);

    this.removeItem = this.removeItem.bind(this);
    this.state = { imageTemplates: props.imageTemplates };
    this.updateImageTemplates = this.updateImageTemplates.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    if (this.props !== nextProps) {
      this.setState({ imageTemplates: nextProps.imageTemplates });
    }
  }

  removeItem(itemIndex) {
    this.props.updateRemovedItems(itemIndex);
  }

  updateImageTemplates(value, index) {
    this.props.updateImageTemplates(value, index);
  }

  render() {
    if (!this.props) {
      return null;
    }
    const imageTemplates = this.state.imageTemplates.map((imageTemplate, index) =>
      <ImageTemplateViewer
        {...imageTemplate}
        key={Math.random()}
        removeItem={this.removeItem}
        index={index}
        updateImageTemplates={this.updateImageTemplates}
      />,
    );
    return (
      <ul className="image-template-list">
        {imageTemplates}
      </ul>
    );
  }
}

ImageTemplateList.propTypes = {
  imageTemplates: PropTypes.arrayOf(
    PropTypes.object,
  ),
  updateRemovedItems: PropTypes.func,
  updateImageTemplates: PropTypes.func,
};

ImageTemplateList.defaultProps = {
  updateRemovedItems: () => {},
  updateImageTemplates: () => {},
};
