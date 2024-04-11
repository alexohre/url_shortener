import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="link-copy-mobile"
export default class extends Controller {
	static targets = ["link", "button"];
	connect() {
		// console.log("connected for mobile");
	}

	async copyMobileLink() {
		// Get the href attribute of the link
		const link = this.linkTarget.getAttribute("href");

		try {
			// Use the Clipboard API to copy the link
			await navigator.clipboard.writeText(link);

			// console.log("Link copied:", link);

			this.buttonTarget.innerHTML =
				'<i class="tf-icons bx bx-check fw-bold"></i> Copied!';
			this.buttonTarget.disabled = true;

			setTimeout(() => {
				this.buttonTarget.innerHTML =
					'<i class="tf-icons bx bx-copy fw-bold"></i> Copy';
				this.buttonTarget.disabled = false;
			}, 3000);
		} catch (error) {
			console.error("Error copying link:", error);
		}
	}
}
