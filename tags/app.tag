<app>
	<video src={ blobURL } ref="localVideo" controls muted={ muted } autoplay></video>
	<button type="button" onclick={ record }>RECORD</button>
	<button type="button" onclick={ stop }>STOP</button>

	<a href={ blobURL }>LINK TO VIDEO</a>

	<script>
		var that = this;
		this.mediaRecorder = null;
		this.muted = true;
		this.stream = null;

		var mediaConstraints = {
	    audio: true,    // don't forget audio!
	    video: true     // don't forget video!
		};

		navigator.mediaDevices.getUserMedia(mediaConstraints).then(function(stream){
			that.stream = stream;
			that.refs.localVideo.src = URL.createObjectURL(stream);

			that.mediaRecorder = new MediaStreamRecorder(stream);
			that.mediaRecorder.mimeType = 'video/webm';
			window.mediaRecorder = that.mediaRecorder;

			that.mediaRecorder.ondataavailable = function(blob){
				console.log('ondataavailable');
				that.blobURL = URL.createObjectURL(blob);
				that.update();
				that.mediaRecorder.save(blob, 'video.webm');
			};

		}).catch(function(error){
		  console.error(error);
		});

		this.record = function(event){
			that.refs.localVideo.src = URL.createObjectURL(that.stream);
			this.muted = true;
			that.mediaRecorder.start();
		};

		this.stop = function(event){
			this.mediaRecorder.stop();
			clearInterval(window.clock);
			// this.refs.localVideo.muted = false;
			this.muted = false;
		};

		// this.record = function(event){
		// 	window.clock = setInterval(function(){
		// 		console.count('seconds');
		// 	}, 1000);
		//
		// 	navigator.mediaDevices.getUserMedia(mediaConstraints)
		// 		.then(function(stream){
		// 			that.mediaRecorder = new MediaStreamRecorder(stream);
		// 			that.mediaRecorder.mimeType = 'video/webm';
		//
		// 			that.mediaRecorder.ondataavailable = function(blob){
		//
		// 				that.blobURL = URL.createObjectURL(blob);
		// 				that.update();
		//
		// 				// document.write('<a href="' + blobURL + '">' + blobURL + '</a>');
		// 			};
		//
		// 			that.mediaRecorder.start();
		// 		}).catch(function(error){
		// 		  console.error('media error', error);
		// 		});
		// };



		this.on('unmount', function(event){
		  that.mediaRecorder = null;
		});

	</script>

	<style>
		:scope {
			display: block;
		}
	</style>
</app>
