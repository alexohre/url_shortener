import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="fetch-title"
export default class extends Controller {
	static targets = ["longUrl", "title"];

	connect() {
		this.longUrlTarget.addEventListener("input", this.debouncedFetchTitle);
	}

	disconnect() {
		this.longUrlTarget.removeEventListener("input", this.debouncedFetchTitle);
	}

	debouncedFetchTitle = this.debounce(this.fetchTitle, 3000); // 4 seconds debounce

	debounce(func, delay) {
		let timeoutId;
		return (...args) => {
			clearTimeout(timeoutId);
			timeoutId = setTimeout(() => {
				func.apply(this, args);
			}, delay);
		};
	}

	fetchTitle() {
		const longUrl = this.longUrlTarget.value.trim();
		if (longUrl === "") return;

		// Fetch CSRF token from meta tags
		const csrfToken = document
			.querySelector('meta[name="csrf-token"]')
			.getAttribute("content");

		fetch("/fetch_title", {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
				Accept: "application/json",
				"X-CSRF-Token": csrfToken,
			},
			body: JSON.stringify({ url: longUrl }),
		})
			.then((response) => {
				if (!response.ok) {
					throw new Error("Network response was not ok");
				}
				return response.json();
			})
			.then((data) => {
				if (!this.titleTarget.value.trim() && data.title) {
					this.titleTarget.value = data.title;
				}
			})
			.catch((error) => {
				console.error("Error fetching title:", error);
			});
	}
}
