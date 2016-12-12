import { RadioGroup, RadioButton } from 'react-toolbox/lib/radio';

class RadioSet extends React.Component {
  state = {
    value: 'kmeans',
  };

  handlechange = (value) => {
    this.setState({ value });
  };

  render() {
    return (
      <RadioGroup name="method" value={this.state.value} onChange={this.handlechange}>
        <RadioButton label="Kmeans" value="kmeans" />
        <RadioButton label="Linear" value="linear" />
      </RadioGroup>
    );
  }
}

return <RadioSet />;
