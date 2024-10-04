create table clients (
  clientId INT AUTO_INCREMENT PRIMARY KEY,
  firstName VARCHAR(50) NOT NULL,
  lastName VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL,
  password VARCHAR(255) NOT NULL,
  username VARCHAR(255) NOT NULL,
  sex enum('MASCULINO', 'FEMENINO'),
  birthday DATE NOT NULL,
  telephone VARCHAR(15) NOT NULL,
  subscriptionPlan enum('BASICO', 'ESTANDAR', 'PREMIUM'),
  UNIQUE (username)
);

CREATE TABLE employees(
  employeeId INT AUTO_INCREMENT PRIMARY KEY,
  firstName VARCHAR(50) NOT NULL,
  lastName VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL,
  password VARCHAR(255) NOT NULL,
  telephone INT NOT NULL,
  adminRol enum('CLIENTES', 'EMPLEADOS', 'PRODUCTOS'),
  UNIQUE (email)
);

CREATE TABLE celebrities(
  celebritieId INT AUTO_INCREMENT PRIMARY KEY,
  firstName VARCHAR(50) NOT NULL,
  lastName VARCHAR(50) NOT NULL,
  sex enum('MASCULINO', 'FEMENINO'),
  birthday DATE NOT NULL,
  webpage VARCHAR(250) NOT NULL,
  UNIQUE (firstName, lastName)
);


CREATE TABLE shows(
  showId INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  description VARCHAR(250) NOT NULL,
  genre VARCHAR(100) NOT NULL,
  UNIQUE (title, description)
);

CREATE TABLE producers (
  producerId INT AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(100) NOT NULL,
  UNIQUE (name)
);

CREATE TABLE televisionNetworks (
  televisionNetworkId INT AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(100) NOT NULL,
  UNIQUE (name)
);

CREATE TABLE movies(
  movieId INT PRIMARY KEY,
  producerId INT NOT NULL,
  movieLength INT NOT NULL,
  releaseDate DATE NOT NULL,
  FOREIGN KEY (movieId) REFERENCES shows (showId),
  FOREIGN KEY (producerId) REFERENCES producers (producerId)
);

CREATE TABLE series(
  serieId INT PRIMARY KEY,
  sesonsNumber INT NOT NULL,
  televisionNetworkId INT NOT NULL,
  FOREIGN KEY (serieId) REFERENCES shows (showId),
  FOREIGN KEY (televisionNetworkId) REFERENCES televisionNetworks (televisionNetworkId)
);

CREATE TABLE seasons(
  seasonId INT AUTO_INCREMENT PRIMARY KEY,
  serieId INT NOT NULL,
  numChapters INT NOT NULL,
  FOREIGN KEY (serieId) REFERENCES series (serieId)
);

CREATE TABLE episodes(
  episodeId INT AUTO_INCREMENT PRIMARY KEY,
  seasonId INT NOT NULL,
  title VARCHAR(250) NOT NULL,
  description VARCHAR(250) NOT NULL,
  episodeLength INT NOT NULL,
  releaseDate DATE NOT NULL,
  FOREIGN KEY (seasonId) REFERENCES seasons(seasonId)
);


CREATE TABLE showsCelebrities(
  celebritieId INT NOT NULL,
  showId INT NOT NULL,
  role enum('DIRECTOR', 'LEADER', 'SUPPORT'),
  FOREIGN KEY (celebritieId) REFERENCES celebrities (celebritieId),
  FOREIGN KEY (showId) REFERENCES shows (showId),
  UNIQUE (celebritieId, showId, role)
);

CREATE TABLE reviews(
  reviewId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  clientId INT NOT NULL,
  title VARCHAR(100) NOT NULL,
  showId INT NOT NULL,
  description VARCHAR(250) NOT NULL,
  reviewDate DATE NOT NULL,
  calification INT CHECK (calification >= 0 AND calification <= 5) NOT NULL,
  FOREIGN KEY (showId) REFERENCES shows (showId),
  FOREIGN KEY (clientId) REFERENCES clients (clientId)
);

CREATE TABLE subtitles(
  subtitleId INT AUTO_INCREMENT PRIMARY KEY,
  language VARCHAR(50) NOT NULL
);

CREATE TABLE moviesSubtitles(
  subtitleId INT NOT NULL,
  FOREIGN KEY (subtitleId) REFERENCES subtitles (subtitleId),
  movieId INT NOT NULL,
  FOREIGN KEY (movieId) REFERENCES movies (movieId)
);










