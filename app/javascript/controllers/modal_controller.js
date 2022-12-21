import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sprintModal", "devModal"]

  open_sprint(event) {
    event.preventDefault();

    this.sprintModalTarget.showModal();

    this.sprintModalTarget.addEventListener('click', (e) => this._backdropClick(e));
  }

  open_dev(event) {
    event.preventDefault();

    this.devModalTarget.showModal();

    this.devModalTarget.addEventListener('click', (e) => this._backdropClick(e));
  }

  close_sprint(event) {
    event.preventDefault();

    this.sprintModalTarget.close();
  }

  close_dev(event) {
    event.preventDefault();

    this.devModalTarget.close();
  }

  _backdropClick(event) {
    event.target === this.sprintModalTarget && this.close_sprint(event)
    event.target === this.devModalTarget && this.close_dev(event)


  }
}
