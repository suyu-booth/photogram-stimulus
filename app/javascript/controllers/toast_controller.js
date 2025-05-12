import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="toast"
export default class extends Controller {
  connect() {
    // Create a new Bootstrap Toast instance associated with this controller's element
    const toast = new bootstrap.Toast(this.element, {
      // Configure the toast to auto-hide after 3000 milliseconds (3 seconds)
      delay: 3000,
      autohide: true
    });
    // Show the toast animation
    toast.show();
  }
}
