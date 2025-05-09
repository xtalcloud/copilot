# Start by building the Go application
FROM golang:1.20 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go modules manifests
COPY go.mod go.sum ./

# Download Go modules
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN go build -o ziinc-copilot main.go

# Use a minimal base image for the final container
FROM gcr.io/distroless/base:nonroot

# Set the working directory inside the container
WORKDIR /

# Copy the built application from the builder stage
COPY --from=builder /app/ziinc-copilot .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the executable
CMD ["/ziinc-copilot"]
