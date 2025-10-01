# Use the official Flutter image as a base
FROM cirrusci/flutter:stable AS build

# Set the working directory
WORKDIR /app

# Copy the pubspec files and get dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the application code
COPY . .

# Build the Flutter web application
RUN flutter build web --release

# Use a lightweight web server to serve the app
FROM nginx:alpine

# Copy the build output to the Nginx HTML directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 3000

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
