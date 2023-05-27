import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $('form').submit(function(){
      $(this).find(':submit').attr('disabled','disabled');
      $(this).find(':submit').val('Please wait ...');

      window.scrollTo(0,0);
      $('#pleaseWaitModal').modal('show');
    });
  }
}
