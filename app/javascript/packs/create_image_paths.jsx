import ReactDOM from 'react-dom';
import LeafletIiif from '../components/leaflet_iiif';
import Histogram from '../components/histogram';

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('image-path-image');
  const data = JSON.parse(node.getAttribute('data'));
  ReactDOM.render(<LeafletIiif {...data} />, node);

  const histograms = document.getElementsByClassName('histogram');

  for (let i = 1; i <= histograms.length; i += 1) {
    const nodeId = `image-path-histogram-${String(i)}`;
    const histogramNode = document.getElementById(nodeId);
    const dataHistogram = JSON.parse(histogramNode.getAttribute('data'));
    ReactDOM.render(<Histogram {...dataHistogram} />, histogramNode);
  }
});
