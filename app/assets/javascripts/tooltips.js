/* globals $, document */

$(document).on('turbolinks:load', () => {
  $('[data-toggle="tooltip"]').tooltip();
});
