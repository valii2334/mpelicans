import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    formid: String
  }

  submitForm() {
    $(`#${this.formidValue}`).validate({
      submitHandler: function(form) {
        $('#form_submit_button').attr('disabled','disabled');
        var myModal = new bootstrap.Modal(document.getElementById('centeredModalPleaseWait'));
        myModal.show();
        setTimeout(() => {
          console.log("Delayed for 1 second.");
          form.submit();
        }, "1000");
        
      }
    });
  }
}