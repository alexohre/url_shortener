import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="previews"
export default class extends Controller {
	static targets = ["input", "preview"];
	connect() {
		// console.log("Previews connencted", this.element);
	}

	// preview() {
	// 	let input = this.inputTarget;
	// 	let preview = this.previewTarget;
	// 	let file = input.files[0];
	// 	let reader = new FileReader();

	// 	reader.onloadend = function () {
	// 		preview.src = reader.result;
	// 	};

	// 	if (file) {
	// 		reader.readAsDataURL(file);
	// 	} else {
	// 		preview.src = "";
	// 	}
	// }

	async preview() {
		let input = this.inputTarget;
		let preview = this.previewTarget;
		let file = input.files[0];

		if (file) {
			const resizedDataURL = await this.resizeImageToFit(file, 100, 100); // Adjust dimensions as needed
			preview.src = resizedDataURL;
		} else {
			preview.src = "";
		}
	}

	async resizeImageToFit(file, width, height) {
		return new Promise((resolve, reject) => {
			const canvas = document.createElement("canvas");
			const ctx = canvas.getContext("2d");
			const image = new Image();
			image.onload = () => {
				const aspectRatio = image.width / image.height;
				let targetWidth = width;
				let targetHeight = height;
				let offsetX = 0;
				let offsetY = 0;
				if (aspectRatio > width / height) {
					targetHeight = height;
					targetWidth = height * aspectRatio;
					offsetX = -(targetWidth - width) / 2;
				} else {
					targetWidth = width;
					targetHeight = width / aspectRatio;
					offsetY = -(targetHeight - height) / 2;
				}
				canvas.width = width;
				canvas.height = height;
				ctx.drawImage(
					image,
					0,
					0,
					image.width,
					image.height,
					offsetX,
					offsetY,
					targetWidth,
					targetHeight
				);
				resolve(canvas.toDataURL());
			};
			image.onerror = reject;
			image.src = URL.createObjectURL(file);
		});
	}
}
