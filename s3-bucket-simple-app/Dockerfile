# Use the official Python slim base image
FROM python:3.9-slim

ARG BUCKET_NAME

# Set the working directory inside the container
WORKDIR /app

# Copy only the necessary files
COPY . .
RUN sed -i "s/BUCKET_NAME = 'thisisjustanexample'/BUCKET_NAME = '${BUCKET_NAME}'/g" app.py

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that the Flask app listens on
EXPOSE 5000

# Run the Flask app when the container starts
CMD ["python", "app.py"]
