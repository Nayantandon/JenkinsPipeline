# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed dependencies specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install glibc
RUN pip install binutils
RUN pip install pyinstaller
RUN apt-get update
RUN  apt-get -y install binutils


# Run pyinstaller to create a standalone executable
RUN pyinstaller --onefile app.py
RUN python app.py

# Expose the port on which your application will run
EXPOSE 5000

# Define environment variable
ENV NAME World

# Run your application when the container launches
CMD ["./dist/app"]
