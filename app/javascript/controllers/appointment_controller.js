import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="appointment"
export default class extends Controller {
  static targets = ["checkbox","professionalLabel"]

  connect() {
    console.log("appointment controller here");
    // console.log(this.professionalLabelTargets)
  }

  checkProfessional(e) {

     // 1. Collect all selected services
     const selectedServices = this.checkboxTargets
      .filter((checkbox) => checkbox.checked)
      .map((checkbox) => {
        const label = checkbox.nextElementSibling;
        return label.querySelector("span").innerText;
      });

    // 2. Update all professionals based on selected services
    this.professionalLabelTargets.forEach((label) => {
      const professionalServices = label.dataset.services.split(',');
      const radioId = label.getAttribute('for');
      const radio = document.getElementById(radioId);

      const hasService = selectedServices.some(service =>
        professionalServices.includes(service)
      );

      radio.disabled = !hasService;

      if (!hasService) {
        radio.checked = false;
      }
    });

  }

}
