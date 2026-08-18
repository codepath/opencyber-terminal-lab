# Image names
IMAGE_NAME=opencyber-terminal-lab

# Default target: build the lab image
all: student

# Build the lab image
student:
	docker build -t $(IMAGE_NAME):local -f docker/Dockerfile .

# Run an interactive container from the local build.
# NO named volume on /home/student: the student's ~/keys/ are GENERATED at build and must
# stay in sync with the servers' authorized_keys, so a persisted home would shadow them with
# stale keys and break key login. The lab is ephemeral by design — each run is a clean box.
run: student
	docker run --rm -it $(IMAGE_NAME):local

# Clean up dangling images (optional)
clean:
	docker image prune -f

# Remove the legacy named volume from the old single-box build (no longer used).
reset:
	-docker volume rm terminal-lab-data

# Run the image from GitHub Container Registry
ghcr:
	docker run --rm -it ghcr.io/codepath/$(IMAGE_NAME):latest

# Build and push to GitHub Container Registry (requires docker login ghcr.io)
push:
	docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/codepath/$(IMAGE_NAME):latest -f docker/Dockerfile --push .
