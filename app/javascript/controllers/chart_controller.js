import { Controller } from "@hotwired/stimulus"
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Chart controller connected");
    this.refreshCharts();

    // Refresh charts when navigating with Turbo
    document.addEventListener("turbo:render", () => {
      this.refreshCharts();
    });
  }

  refreshCharts() {
    // Wait for Chartkick to be fully loaded
    setTimeout(() => {
      if (typeof Chartkick !== 'undefined') {
        Chartkick.eachChart((chart) => {
          chart.redraw();
        });
        console.log("Charts refreshed");
      } else {
        console.error("Chartkick not available for refresh");
      }
    }, 300);
  }
}
export default class extends Controller {
  connect() {
    console.log("Chart controller connected");

    // Ensure Chart.js is available and initialized with Chartkick
    if (window.Chartkick && window.Chart) {
      window.Chartkick.use(window.Chart);
      console.log("Chartkick initialized with Chart.js");
    } else {
      console.error("Chartkick or Chart.js not available");
    }
  }
}
