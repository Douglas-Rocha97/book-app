import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dashboard"
export default class extends Controller {

  static targets = [ "list", "calendar" ]

  showAppointments(e) {
    const selectedDay = e.currentTarget.closest("td")
    const date = e.currentTarget.dataset.date
    const url = `/owner/dashboard/show_appointments?date=${date}`

    fetch(url)
    .then(response => response.text()
     )
    .then(html => this.listTarget.innerHTML = html
    )

    this.calendarTarget.querySelectorAll(".day-selector").forEach(day=>{
      day.classList.remove("selected")
    })

    this.listTarget.innerHTML = ''

    if (!selectedDay || selectedDay.classList.contains("past") || selectedDay.classList.contains("wday-0")){
      return
    }else{
      selectedDay.querySelector(".day-selector").classList.add("selected")
    }
  }
}
