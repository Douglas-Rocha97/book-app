import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="appointment"
export default class extends Controller {
  static targets = ["checkbox","professionalLabel", "professionalsList", "calendar", "timesList"]

  connect() {

  }

  checkProfessional() {

     // 1. Collect all service_ids if checked (array of strings)
    const selectedServiceIds = this.checkboxTargets
      .filter(cb=> cb.checked).map(cb=> cb.value);

    // 2. Update all professionals based on selected services
    this.professionalLabelTargets.forEach((label) => {
      const professionalServiceIds = label.dataset.services.split(',');// array of strings
      const radio = document.getElementById(label.getAttribute('for'))

      const hasService = selectedServiceIds.some(service =>
        professionalServiceIds.includes(service)
      );

      radio.disabled = !hasService;

      if (!hasService) {
        radio.checked = false;
      }
    });

    const professionals = Array.from(this.professionalsListTarget.children);

    professionals.sort((divA, divB) => {
      const labelA = divA.querySelector("label");
      const labelB = divB.querySelector("label");

      const radioA = document.getElementById(labelA.getAttribute("for"));
      const radioB = document.getElementById(labelB.getAttribute("for"));

      // Enabled professionals come first
      return (radioA.disabled === radioB.disabled) ? 0 : (radioA.disabled ? 1 : -1);
    });

    // 4. Re-append sorted professionals to the container
    professionals.forEach(prof => this.professionalsListTarget.appendChild(prof));

  }

  selectDate(e) {
    const selectedDay = e.target
    if (selectedDay.classList.contains("past")||selectedDay.classList.contains("wday-0"))return

    this.calendarTarget.querySelectorAll("td").forEach(day => {
      day.classList.remove("selected")
    })

    selectedDay.classList.add("selected")
  }


}
