/* global ImageTemplateViewer */

class ImageTemplateList extends React.Component {
  constructor(props) {
    super(props);

    this.removeItem = this.removeItem.bind(this);
    this.state = { imageTemplates: props.imageTemplates };
  }

  componentWillReceiveProps(nextProps) {
    if (this.props !== nextProps) {
      this.setState({ imageTemplates: nextProps.imageTemplates });
    }
  }

  removeItem(itemIndex) {
    this.props.updateRemovedItems(itemIndex);
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
  imageTemplates: React.PropTypes.arrayOf(
    React.PropTypes.object,
  ),
  updateRemovedItems: React.PropTypes.func,
};

ImageTemplateList.defaultProps = {
  updateRemovedItems: () => {},
};
