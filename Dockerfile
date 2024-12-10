### STAGE 1: Build ###
# Utiliser Node.js version alpine
FROM node:12.7-alpine AS build

# Définir le répertoire de travail
WORKDIR /usr/src/app

# Copier les fichiers package.json et package-lock.json
COPY package.json package-lock.json ./

# Installer les dépendances
RUN npm install

# Copier tout le contenu du projet
COPY . .

# Builder le projet Angular
RUN npm run build

### STAGE 2: Run ###
# Utiliser Nginx comme base
FROM nginx:1.17.1-alpine

# Copier la configuration nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copier l'application Angular générée depuis le dossier "dist"
COPY --from=build /usr/src/app/dist/aston-villa-app /usr/share/nginx/html

