import ReactDOM from 'react-dom';
import ToggleForm from '../components/toggle_form';
import PosterizeForm from '../components/posterize_form';

document.addEventListener('DOMContentLoaded', () => {
  const denoiseNode = document.getElementById('image-clean-denoise');
  const denoiseData = JSON.parse(denoiseNode.getAttribute('data'));
  ReactDOM.render(<ToggleForm {...denoiseData} />, denoiseNode);

  const equalizeNode = document.getElementById('image-clean-equalize');
  const equalizeData = JSON.parse(equalizeNode.getAttribute('data'));
  ReactDOM.render(<ToggleForm {...equalizeData} />, equalizeNode);

  const brightnessNode = document.getElementById('image-clean-brightness');
  const brightnessData = JSON.parse(brightnessNode.getAttribute('data'));
  ReactDOM.render(<ToggleForm {...brightnessData} />, brightnessNode);

  const contrastNode = document.getElementById('image-clean-contrast');
  const contrastData = JSON.parse(contrastNode.getAttribute('data'));
  ReactDOM.render(<ToggleForm {...contrastData} />, contrastNode);

  const smoothNode = document.getElementById('image-clean-smooth');
  const smoothData = JSON.parse(smoothNode.getAttribute('data'));
  ReactDOM.render(<ToggleForm {...smoothData} />, smoothNode);

  const posterizeNode = document.getElementById('image-clean-posterize');
  const posterizeData = JSON.parse(posterizeNode.getAttribute('data'));
  ReactDOM.render(<PosterizeForm {...posterizeData} />, posterizeNode);
});
