<app>
	<video src={ blobURL } ref="localVideo" controls muted={ muted } autoplay></video>
	<button type="button" onclick={ record }>RECORD</button>
	<button type="button" onclick={ stop }>STOP</button>

	<a href={ blobURL }>LINK TO VIDEO</a>

	<script>
		var that = this;

		this.mediaRecorder = null;
		this.stream = null;

		this.muted = true;

		var mediaConstraints = {
	    audio: true,
	    video: true
		};

		navigator.mediaDevices.getUserMedia(mediaConstraints).then(function(stream){
			console.log('x', that.refs.localVideo);
			that.stream = stream;
			that.refs.localVideo.src = URL.createObjectURL(stream);

			that.mediaRecorder = new MediaStreamRecorder(stream);
			that.mediaRecorder.mimeType = 'video/webm';

			// So we can view it in console easily...
			// window.mediaRecorder = that.mediaRecorder;

			that.mediaRecorder.ondataavailable = function(blob){
				console.log('ondataavailable');
				that.blobURL = URL.createObjectURL(blob);
				that.update();
				that.mediaRecorder.save(blob, 'video.webm');
			};

			that.update();

		}).catch(function(error){
		  console.error(error);
		});

		this.record = function(event){
			console.log('record');
			that.refs.localVideo.src = URL.createObjectURL(that.stream);
			this.muted = true;
			that.mediaRecorder.start();
		};

		this.stop = function(event){
			console.log('stop');
			clearInterval(window.clock);
			this.mediaRecorder.stop();
			this.muted = false;
		};

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
