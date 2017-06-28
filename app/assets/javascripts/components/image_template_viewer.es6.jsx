/* global Range */

class ImageTemplateViewer extends React.Component {
  constructor(props) {
    super(props);
    this.state = { value: parseInt(props.match_options.threshold, 10) };

    this.handleChange = this.handleChange.bind(this);
    this.handleClose = this.handleClose.bind(this);
  }

  handleChange(value) {
    this.setState({ value }, () => {
      this.updateImageTemplates(this.state.value, this.props.index);
    });
  }

  handleClose() {
    this.props.removeItem(this.props.index);
  }

  updateImageTemplates(value, index) {
    this.props.updateImageTemplates(value, index);
  }

  render() {
    if (!this.props) {
      return null;
    }
    return (
      <li className="list-group-item">
        <button
          type="button"
          className="close"
          aria-label="Close"
          onClick={this.handleClose}
        >
          <span aria-hidden="true">&times;</span>
        </button>
        <div className="container">
          <div className="row">
            <div className="col">
              <img
                src={this.props.image_url}
                alt="Template"
                className="img-thumbnail rounded mx-auto d-block"
              />
            </div>
          </div>
        </div>
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
        <div className="container">
          <div className="row">
            <div className="col">
              <div className="form-group row">
                <label htmlFor={`a${Math.random()}`} className="col-3 col-form-label">
                  Threshold: {this.state.value}
                </label>
                <div className="col-9">
                  <Range
                    fieldName="collection_template[image_templates_attributes][][match_options][threshold]"
                    value={parseInt(this.state.value, 10)}
                    enabled
                    onUpdate={this.handleChange}
                    className="align-middle"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
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
  match_options: React.PropTypes.shape({
    threshold: React.PropTypes.oneOfType([
      React.PropTypes.number,
      React.PropTypes.string,
    ]),
  }),
  removeItem: React.PropTypes.func,
  index: React.PropTypes.number,
  updateImageTemplates: React.PropTypes.func,
};

ImageTemplateViewer.defaultProps = {
  id: '',
  match_options: {
    threshold: 80,
  },
  removeItem: () => {},
  index: null,
  updateImageTemplates: () => {},
};
