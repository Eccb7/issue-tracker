// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "controllers"
import "./controllers"

// Direct import of Chartkick with Chart.js
import "chartkick/chart.js"

// Handle Turbo confirmation dialogs for delete actions
document.addEventListener("turbo:before-visit", (event) => {
  const confirmText = event.detail.confirmation?.toString();
  if (confirmText && !window.confirm(confirmText)) {
    event.preventDefault();
  }
});

document.addEventListener("turbo:submit-start", (event) => {
  const form = event.target;
  if (form.dataset.turboConfirm && !window.confirm(form.dataset.turboConfirm)) {
    event.preventDefault();
  }
});

document.addEventListener("DOMContentLoaded", () => {
  // Fix for delete buttons in Rails 7 with Turbo
  document.querySelectorAll('form[method="post"][action$="_method=delete"]').forEach(form => {
    form.addEventListener('submit', (event) => {
      if (form.dataset.turboConfirm && !confirm(form.dataset.turboConfirm)) {
        event.preventDefault();
      }
    });
  });
});

// Make sure Chartkick is available globally
window.addEventListener("turbo:load", () => {
  console.log("Charts initializing...");

  // Force refresh any charts
  if (typeof Chartkick !== 'undefined') {
    Chartkick.eachChart((chart) => {
      chart.redraw();
    });
    console.log("Charts initialized successfully");
  } else {
    console.error("Chartkick not available");
  }
});

// Handle Turbo confirmation dialogs
document.addEventListener("turbo:submit-start", ({ target }) => {
  const confirmMessage = target.dataset.turboConfirm;
  if (confirmMessage && !confirm(confirmMessage)) {
    event.preventDefault();
    event.stopImmediatePropagation();
  }
});
