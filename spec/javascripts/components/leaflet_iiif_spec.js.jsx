import LeafletIiif from '../../../app/javascript/components/leaflet_iiif';

describe('LeafletIiif', () => {
  xit('sets up the iiif layer', () => {
    const component = TestUtils.renderIntoDocument(
      <LeafletIiif
        iiifImage="https://stacks.stanford.edu/image/iiif/hg676jb4964%2F0380_796-44/info.json"
      />,
    );
    const container = TestUtils.findRenderedDOMComponentWithClass(component, 'leaflet-container');
    expect(container).not.toBe(null);
  });
});
