/* eslint react/jsx-no-undef: "off" */
/* global Range */

function simplificationMethodName(abbrev) {
  return (abbrev === 'vw') ? 'Visvalingam-Whyatt' : 'Ramer-Douglas-Peucker';
}

class Graph extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      simplificationMethod: props.simplificationMethod,
      simplificationTolerance: parseInt(props.simplificationTolerance, 10),
      format: props.format,
    };
    this.handleMethodChange = this.handleMethodChange.bind(this);
    this.handleToleranceChange = this.handleToleranceChange.bind(this);
    this.handleFormatChange = this.handleFormatChange.bind(this);
  }

  handleMethodChange(event) {
    this.setState({ simplificationMethod: event.target.value });
  }

  handleToleranceChange(simplificationTolerance) {
    this.setState({ simplificationTolerance: parseInt(simplificationTolerance, 10) });
  }

  handleFormatChange(event) {
    this.setState({ format: event.target.value });
  }

  render() {
    if (!this.props) {
      return null;
    }
    return (
      <div>
        <div className="form-group row">
          <label
            className="col-sm-3 form-text text-capitalize"
            data-toggle="tooltip"
            htmlFor="simplification-method"
          >
            Simplification Method
          </label>

          <div className="col-sm-6">
            <select
              name="collection_template[graph][simplification-method]"
              value={this.state.simplificationMethod}
              onChange={this.handleMethodChange}
              className={'form-control'}
            >
              { this.props.simplificationMethods.map(method =>
                (<option value={method.toLowerCase()} key={Math.random()}>
                  {simplificationMethodName(method)}
                </option>),
                )}
            </select>
          </div>
        </div>
        <div className="form-group row">
          <label
            className="col-sm-3 form-text text-capitalize"
            data-toggle="tooltip"
            htmlFor="simplificationTolerance"
          >Simplification Tolerance
          </label>
          <div className="col-sm-6">
            <Range
              fieldName="collection_template[graph][simplification-tolerance]"
              value={this.state.simplificationTolerance}
              enabled
              onUpdate={this.handleToleranceChange}
              className="align-middle"
              max={10}
            />
          </div>
          <div className="col-sm-2">
            {this.state.simplificationTolerance}
          </div>
        </div>
        <div className="form-group row">
          <label
            className="col-sm-3 form-text text-capitalize"
            data-toggle="tooltip"
            htmlFor="format"
          >
            Graph format
          </label>
          <div className="col-sm-6">
            <select
              name="collection_template[graph][format]"
              value={this.state.format}
              onChange={this.handleFormatChange}
              className={'form-control'}
            >
              { this.props.formats.map(format =>
                <option value={format.toLowerCase()} key={Math.random()}>{format}</option>,
                )}
            </select>
          </div>
        </div>
      </div>
    );
  }
}

Graph.propTypes = {
  simplificationMethod: React.PropTypes.string,
  simplificationMethods: React.PropTypes.arrayOf(React.PropTypes.string),
  simplificationTolerance: React.PropTypes.string,
  format: React.PropTypes.string,
  formats: React.PropTypes.arrayOf(React.PropTypes.string),
};

Graph.defaultProps = {
  simplificationMethod: 'vw',
  simplificationMethods: ['vw', 'rdp'],
  simplificationTolerance: '0',
  format: 'graphml',
  formats: ['edgelist', 'gexf', 'gml', 'graphml', 'nodelink'],
};
