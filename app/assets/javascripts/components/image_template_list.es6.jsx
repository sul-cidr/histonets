/* global ImageTemplateViewer */

class ImageTemplateList extends React.Component {

  render() {
    if (!this.props) {
      return null;
    }
    const imageTemplates = this.props.imageTemplates.map(imageTemplate => (
      <ImageTemplateViewer
        {...imageTemplate}
        key={Math.random()}
      />
      ),
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
};
