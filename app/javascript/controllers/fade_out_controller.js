import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $(".alert").delay(2000).fadeOut(300);
  }
}
