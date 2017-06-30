import ReactDOM from 'react-dom';
import IiifCropper from '../components/iiif_cropper';

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('iiif-cropper');
  const data = JSON.parse(node.getAttribute('data'));

  ReactDOM.render(<IiifCropper {...data} />, node);
});
