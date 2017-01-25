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
          name="collection_template[image_templates_attributes][][image_url]"
          value={this.props.image_url}
        />
        <input
          type="hidden"
          name="collection_template[image_templates_attributes][][id]"
          value={this.props.id}
        />
      </li>
    );
  }
}

ImageTemplateViewer.propTypes = {
  image_url: React.PropTypes.string,
  id: React.PropTypes.oneOfType([
    React.PropTypes.string,
    React.PropTypes.number,
  ]),
};

ImageTemplateViewer.defaultProps = {
  id: '',
};
