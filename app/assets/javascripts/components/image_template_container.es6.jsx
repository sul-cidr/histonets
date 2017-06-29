/* global ImageTemplateCropper, ImageTemplateList, $  */

class ImageTemplateContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      imageTemplates: props.imageTemplates,
    };

    this.updateRemovedItems = this.updateRemovedItems.bind(this);
    this.onAddNewTemplate = this.onAddNewTemplate.bind(this);
    this.updateImageTemplates = this.updateImageTemplates.bind(this);
  }

  onAddNewTemplate(cropperState) {
    const imageTemplates = this.state.imageTemplates;
    imageTemplates.push({
      image_url: this.regionToImageUrl(cropperState.region),
      match_options: { threshold: 80 },
    });
    this.setState({
      imageTemplates,
    });
  }

  updateRemovedItems(itemIndex) {
    // This would have been much nicer with Redux
    const newTemplates = this.state.imageTemplates.slice();
    const itemToRemove = newTemplates[itemIndex];
    let removeFromList = false;
    // If it doesn't have an id than its not persisted, if it does we need to
    // delete it.
    if (itemToRemove.id) {
      $.ajax({
        url: `${this.props.templateDestroyRoute}${itemToRemove.id}`,
        type: 'DELETE',
        success(result) {
          removeFromList = result;
        },
      });
    } else {
      removeFromList = true;
    }
    if (removeFromList) {
      newTemplates.splice(itemIndex, 1);
      this.setState({ imageTemplates: newTemplates });
    }
  }

  regionToImageUrl(region) {
    return `${this.props.iiifImage.replace('/info.json', '')}/${region.join(',')}/full/0/default.png`;
  }

  updateImageTemplates(value, index) {
    this.threshold = value;
    this.index = index;
    this.state.imageTemplates[index].match_options.threshold = value;
  }

  render() {
    if (!this.props) {
      return null;
    }
    return (
      <div className="row">
        <div className="col-md-6">
          <ImageTemplateCropper
            {...this.props}
            onAddNewTemplate={this.onAddNewTemplate}
          />
        </div>
        <div className="col-md-6">
          <ImageTemplateList
            imageTemplates={this.state.imageTemplates}
            updateRemovedItems={this.updateRemovedItems}
            updateImageTemplates={this.updateImageTemplates}
          />
        </div>
      </div>
    );
  }
}

ImageTemplateContainer.propTypes = {
  imageTemplates: React.PropTypes.arrayOf(
    React.PropTypes.object,
  ),
  iiifImage: React.PropTypes.string,
  templateDestroyRoute: React.PropTypes.string,
};

ImageTemplateContainer.defaultProps = {
  templateDestroyRoute: '',
};
