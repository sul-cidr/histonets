import ReactDOM from 'react-dom';
import ImageTemplateContainer from '../components/image_template_container';

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('image-template-container');
  const data = JSON.parse(node.getAttribute('data'));

  ReactDOM.render(<ImageTemplateContainer {...data} />, node);
});
