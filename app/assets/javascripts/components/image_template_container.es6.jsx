/* global ImageTemplateCropper, ImageTemplateList  */

class ImageTemplateContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      imageTemplates: props.imageTemplates,
    };
    this.onAddNewTemplate = this.onAddNewTemplate.bind(this);
  }

  onAddNewTemplate(cropperState) {
    const imageTemplates = this.state.imageTemplates;
    imageTemplates.push({
      image_url: this.regionToImageUrl(cropperState.region),
    });
    this.setState({
      imageTemplates,
    });
  }

  regionToImageUrl(region) {
    return `${this.props.iiifImage.replace('/info.json', '')}/${region.join(',')}/full/0/default.png`;
  }

  render() {
    if (!this.props) {
      return null;
    }
    return (
      <div className="row">
        <div className="col-md-8">
          <ImageTemplateCropper
            {...this.props}
            onAddNewTemplate={this.onAddNewTemplate}
          />
        </div>
        <div className="col-md-4">
          <ImageTemplateList imageTemplates={this.state.imageTemplates} />
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
};
