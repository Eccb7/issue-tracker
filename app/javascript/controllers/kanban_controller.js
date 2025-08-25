import { Controller } from "@hotwired/stimulus"
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["column", "card"]

  connect() {
    console.log("Kanban controller connected")
    this.initializeDragAndDrop()
  }

  initializeDragAndDrop() {
    this.cardTargets.forEach(card => {
      card.setAttribute("draggable", "true")

      card.addEventListener("dragstart", e => {
        e.dataTransfer.setData("text/plain", card.dataset.issueId)
        e.dataTransfer.effectAllowed = "move"
        card.classList.add("dragging")
      })

      card.addEventListener("dragend", e => {
        card.classList.remove("dragging")
      })
    })

    this.columnTargets.forEach(column => {
      column.addEventListener("dragover", e => {
        e.preventDefault()
        e.dataTransfer.dropEffect = "move"
        column.classList.add("drag-over")
      })
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="kanban"
export default class extends Controller {
  static targets = ["column", "card"]

  connect() {
    this.initDragAndDrop()
  }

  initDragAndDrop() {
    // Initialize drag-and-drop for each card
    this.cardTargets.forEach(card => {
      card.setAttribute("draggable", true)

      card.addEventListener("dragstart", (e) => {
        e.dataTransfer.setData("text/plain", card.dataset.issueId)
        card.classList.add("dragging")
      })

      card.addEventListener("dragend", () => {
        card.classList.remove("dragging")
      })
    })

    // Initialize drop targets for each column
    this.columnTargets.forEach(column => {
      column.addEventListener("dragover", (e) => {
        e.preventDefault()
        column.classList.add("drag-over")
      })

      column.addEventListener("dragleave", () => {
        column.classList.remove("drag-over")
      })

      column.addEventListener("drop", (e) => {
        e.preventDefault()
        column.classList.remove("drag-over")

        const issueId = e.dataTransfer.getData("text/plain")
        const newStatus = column.dataset.status

        this.updateIssueStatus(issueId, newStatus)
      })
    })
  }

  updateIssueStatus(issueId, newStatus) {
    // Send a request to update the issue status
    fetch(`/issues/${issueId}/update_status`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ status: newStatus })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        // Reload the page to show the updated kanban board
        window.location.reload()
      } else {
        console.error("Failed to update issue status:", data.errors)
        alert("Failed to update issue status")
      }
    })
    .catch(error => {
      console.error("Error:", error)
      alert("An error occurred while updating the issue")
    })
  }

  changeStatus(event) {
    event.preventDefault()
    const button = event.currentTarget
    const issueId = button.dataset.issueId
    const newStatus = button.dataset.status

    this.updateIssueStatus(issueId, newStatus)
  }
}
      column.addEventListener("dragleave", e => {
        column.classList.remove("drag-over")
      })

      column.addEventListener("drop", e => {
        e.preventDefault()
        const issueId = e.dataTransfer.getData("text/plain")
        const newStatus = column.dataset.status

        column.classList.remove("drag-over")

        // Send AJAX request to update issue status
        this.updateIssueStatus(issueId, newStatus)
      })
    })
  }

  updateIssueStatus(issueId, newStatus) {
    const csrfToken = document.querySelector("meta[name='csrf-token']").content

    fetch(`/issues/${issueId}/update_status`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify({ status: newStatus })
    })
    .then(response => {
      if (response.ok) {
        return response.json()
      }
      throw new Error('Network response was not ok')
    })
    .then(data => {
      if (data.success) {
        // Move the card to the new column
        const card = document.querySelector(`[data-issue-id="${issueId}"]`)
        const targetColumn = document.querySelector(`[data-status="${newStatus}"]`)
        targetColumn.appendChild(card)
      }
    })
    .catch(error => {
      console.error('Error updating issue status:', error)
      alert("Failed to update issue status. Please try again.")
    })
  }
}
export default class extends Controller {
  static targets = ["column", "card"]

  connect() {
    console.log("Kanban controller connected")
    this.initializeDragAndDrop()
  }

  initializeDragAndDrop() {
    this.cardTargets.forEach(card => {
      card.setAttribute("draggable", "true")

      card.addEventListener("dragstart", e => {
        e.dataTransfer.setData("text/plain", card.dataset.issueId)
        e.dataTransfer.effectAllowed = "move"
        card.classList.add("dragging")
      })

      card.addEventListener("dragend", e => {
        card.classList.remove("dragging")
      })
    })

    this.columnTargets.forEach(column => {
      column.addEventListener("dragover", e => {
        e.preventDefault()
        e.dataTransfer.dropEffect = "move"
        column.classList.add("drag-over")
      })
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="kanban"
export default class extends Controller {
  static targets = ["column", "card"]

  connect() {
    this.setupDragAndDrop()
  }

  setupDragAndDrop() {
    // Make cards draggable
    this.cardTargets.forEach(card => {
      card.setAttribute("draggable", true)

      card.addEventListener("dragstart", (e) => {
        e.dataTransfer.setData("text/plain", card.dataset.issueId)
        card.classList.add("dragging")
      })

      card.addEventListener("dragend", () => {
        card.classList.remove("dragging")
      })
    })

    // Set up drop zones
    this.columnTargets.forEach(column => {
      column.addEventListener("dragover", (e) => {
        e.preventDefault()
        column.classList.add("drag-over")
      })

      column.addEventListener("dragleave", () => {
        column.classList.remove("drag-over")
      })

      column.addEventListener("drop", (e) => {
        e.preventDefault()
        column.classList.remove("drag-over")

        const issueId = e.dataTransfer.getData("text/plain")
        const newStatus = column.dataset.status

        this.updateIssueStatus(issueId, newStatus)
      })
    })
  }

  updateIssueStatus(issueId, newStatus) {
    // Always ensure we're using the correct status names
    if (newStatus === 'new') {
      newStatus = 'new_issue';
    }

    const csrfToken = document.querySelector("meta[name='csrf-token']").content

    fetch(`/issues/${issueId}/update_status`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify({ status: newStatus })
    })
    .then(response => {
      if (response.ok) {
        return response.json()
      }
      throw new Error('Network response was not ok')
    })
    .then(data => {
      if (data.success) {
        window.location.reload()
      } else {
        console.error("Failed to update issue status:", data.errors)
      }
    })
    .catch(error => {
      console.error("Error updating issue status:", error)
    })
  }
}
      column.addEventListener("dragleave", e => {
        column.classList.remove("drag-over")
      })

      column.addEventListener("drop", e => {
        e.preventDefault()
        const issueId = e.dataTransfer.getData("text/plain")
        const newStatus = column.dataset.status

        column.classList.remove("drag-over")

        // Send AJAX request to update issue status
        this.updateIssueStatus(issueId, newStatus)
      })
    })
  }

  updateIssueStatus(issueId, newStatus) {
    const csrfToken = document.querySelector("meta[name='csrf-token']").content

    fetch(`/issues/${issueId}/update_status`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify({ status: newStatus })
    })
    .then(response => {
      if (response.ok) {
        return response.json()
      }
      throw new Error('Network response was not ok')
    })
    .then(data => {
      if (data.success) {
        // Move the card to the new column
        const card = document.querySelector(`[data-issue-id="${issueId}"]`)
        const targetColumn = document.querySelector(`[data-status="${newStatus}"]`)
        targetColumn.appendChild(card)
      }
    })
    .catch(error => {
      console.error('Error updating issue status:', error)
      alert("Failed to update issue status. Please try again.")
    })
  }
}
