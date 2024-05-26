# Use a multi-stage build to compile the Go code
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copy the Go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application for ARM architecture
RUN GOARCH=arm64 GOOS=linux go build -o main .

# Use a minimal base image for the final image
FROM alpine:latest

WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/main .

# Expose the port
EXPOSE 6667

# Command to run the application
CMD ["./main"]
