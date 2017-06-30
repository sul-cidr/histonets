import ReactDOM from 'react-dom';
import ImageMatchResults from '../components/image_match_results';

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('image-match-results');
  const data = JSON.parse(node.getAttribute('data'));

  ReactDOM.render(<ImageMatchResults {...data} />, node);
});
