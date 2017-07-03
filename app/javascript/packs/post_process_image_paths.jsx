import ReactDOM from 'react-dom';
import LeafletIiif from '../components/leaflet_iiif';

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('post-processed-image-paths');
  const data = JSON.parse(node.getAttribute('data'));

  ReactDOM.render(<LeafletIiif {...data} />, node);
});
