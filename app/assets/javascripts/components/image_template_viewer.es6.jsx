class ImageTemplateViewer extends React.Component {
  render() {
    if (!this.props) {
      return null;
    }
    return (
      <li className="list-group-item">
        <img
          src={this.props.image_url}
          alt="Template"
          style={{ maxWidth: '100%' }}
        />
        <input
          type="hidden"
          name={`collection_template[image_templates_attributes][${this.props.id}][image_url]`}
          value={this.props.image_url}
        />
      </li>
    );
  }
}

ImageTemplateViewer.propTypes = {
  image_url: React.PropTypes.string,
  id: React.PropTypes.string,
};

ImageTemplateViewer.defaultProps = {
  id: '',
};
