# Use the official Ubuntu image as the base image
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Install necessary dependencies 
RUN apk update && apk add --no-cache \
    g++ \
    boost-dev \
    openssl-dev \
    cmake \
    cpprest-dev \
     make

# Copy the source code into the container
COPY main.cpp .

# Compile the C++ code
RUN make main

# Expose the port on which the API will listen
EXPOSE 8080

# Command to run the API when the container starts
CMD ["./main"]
