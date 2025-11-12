import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="appointment"
export default class extends Controller {
  static targets = ["checkbox", "date", "professionalLabel",
     "professionalsList", "calendar", "timesList", "time",
     "serviceError", "professionalError", "dateTimeError"
    ]

  connect() {

  }

  checkProfessional(e) {
    this.serviceErrorTarget.innerText = ""
    if (!e.target.checked) {
      const professionalsList = this.professionalsListTarget.querySelectorAll("input")
      professionalsList.forEach(professional => professional.checked = false)
    }

     // 1. Collect all service_ids if checked (array of strings)
    const selectedServiceIds = this.checkboxTargets
      .filter(cb=> cb.checked)
      .map(cb=> cb.value);

    // 2. Update all professionals based on selected services
    this.professionalLabelTargets.forEach((label) => {
      const professionalServiceIds = label.dataset.services.split(',');// array of strings
      const radio = document.getElementById(label.getAttribute('for'))

      const hasService = selectedServiceIds.every(service =>
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

    const selectedRadio = this.professionalsListTarget.querySelector("input[type='radio']:checked");
      if (!selectedRadio || selectedRadio.disabled) {
      this.calendarEnabled = false;
      this.dateTarget.value = ""
      this.calendarTarget.querySelectorAll("td").forEach(day => {
      day.classList.remove("selected")
    })
    }
  }

  enableCalendar(e) {
    this.professionalErrorTarget.innerText=""
    const selectedRadio = e.target

    if (!selectedRadio.checked) this.calendarEnabled = false

    this.selectedProfessionalId = selectedRadio.value
    this.calendarEnabled = true
  }

  selectDate(e) {
    if (!this.calendarEnabled) {
      console.warn("pick a professional");
      return
    }

    const selectedDay = e.target.closest("td")

    if (!selectedDay || selectedDay.classList.contains("past")||selectedDay.classList.contains("wday-0"))return

    this.calendarTarget.querySelectorAll(".day-selector").forEach(day => {
      day.classList.remove("selected")
    })

    selectedDay.querySelector(".day-selector").classList.add("selected")
    this.dateTimeErrorTarget.innerText = ""

    const dateDiv = selectedDay.querySelector("[data-date]")
    if (!dateDiv) return

    const selectedDate = dateDiv.dataset.date
    const input = this.dateTarget
    input.value = selectedDate

    if (!this.selectedProfessionalId) {
      console.warn("pick a professional");
      return
    }

    this.loadAvailableTimes(selectedDate, this.selectedProfessionalId)
  }

  async loadAvailableTimes(date, professionalId) {
    try {
      // coleta services selecionados (filtra vazios e null)
      const selectedServiceIds = this.checkboxTargets
        .filter(cb => cb.checked)
        .map(cb => String(cb.value).trim())
        .filter(id => id !== "" && id !== "null" && id !== "undefined");

      if (selectedServiceIds.length === 0) {
        this.timesListTarget.innerHTML = "<p class='text-muted'>Please select at least one service.</p>";
        return;
      }

      // monta query de forma robusta
      const query = new URLSearchParams({
        professional_id: professionalId,
        date: date
      });
      selectedServiceIds.forEach(id => query.append("service_ids[]", id));

      const url = `/appointments/available_times?${query.toString()}`;
      // console.log("REAL URL BEING FETCHED:", url);

      const response = await fetch(url, {
        headers: {
          "Accept": "application/json"
        }
      });

      if (!response.ok) {
        // mostra erro mais amigável no UI
        console.error("Server returned not ok:", response.status, response.statusText);
        this.timesListTarget.innerHTML = `<p class="text-danger">No available times (server returned ${response.status}).</p>`;
        return;
      }

      const contentType = response.headers.get("content-type") || "";
      if (!contentType.includes("application/json")) {
        // se veio HTML, loga e mostra a mensagem em vez de quebrar o JSON.parse
        const text = await response.text();
        console.error("Expected JSON but got:", text);
        this.timesListTarget.innerHTML = "<p class='text-danger'>Unexpected server response. Check logs.</p>";
        return;
      }

      const data = await response.json();

      if (data.message) {
        this.timesListTarget.innerHTML = `<p class='text-light'>${data.message}</p>`;
        return;
      }

      // data deve ser array de strings ["09:00", "09:30"]
      if (!Array.isArray(data) || data.length === 0) {
        this.timesListTarget.innerHTML = "<p class='text-muted'>No available times for this date.</p>";
        return;
      }

      this.renderTimes(data);
    } catch (error) {
      console.error("error fetching available times:", error);
      this.timesListTarget.innerHTML = "<p class='text-danger'>Error loading times.</p>";
    }
  }

  renderTimes(times) {
    this.timesListTarget.innerHTML = ''
    times.forEach(time => {
      const div = document.createElement('div')
      const input = document.createElement("input")
      input.type = "radio"
      input.name = "appointment[start_time]"
      input.dataset.time = time
      input.id = time
      input.classList = "tag-selector"
      input.dataset.action = "change->appointment#selectTime"
      const label = document.createElement("label")
      label.htmlFor = time
      label.innerText = time
      div.appendChild(input)
      div.appendChild(label)
      this.timesListTarget.appendChild(div)
    })
  }

  selectTime(e) {
    const time = e.target.dataset.time
    this.timeTarget.value = time
  }

  validateForm(e){
    let isValid = true
    const selectedService = this.checkboxTargets.filter(cb=> cb.checked)
    if(selectedService.length === 0) {
      this.serviceErrorTarget.innerText = "Please select at least one service."
      isValid = false
    }

    const selectedProfessional = Array.from(this.professionalsListTarget.querySelectorAll("input[type='radio']:enabled"))
    .find(radio => radio.checked);

    if(!selectedProfessional) {
      this.professionalErrorTarget.innerText="Please select at least one professional."
      isValid = false
    }

    const date = this.dateTarget.value
    const time = this.timeTarget.value

    if(!date||!time) {
      this.dateTimeErrorTarget.innerText = "Please select a date and time"
      isValid = false
    }

    if(!isValid) {
      e.preventDefault()
    }
  }

}
