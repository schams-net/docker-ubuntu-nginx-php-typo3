# Docker: Ubuntu + nginx + PHP-FPM + TYPO3

## Description

This is a **prototype** of an Ubuntu-based Docker image featuring [nginx](https://nginx.org), [PHP-FPM](https://www.php.net/manual/install.fpm.php), [Composer](https://getcomposer.org/), and [TYPO3](https://typo3.org).

## Download and Build

```bash
git clone https://github.com/schams-net/docker-ubuntu-nginx-php-typo3.git
```

The following commands build a new Docker image, tagged as `prototype`, based on the official [Ubuntu Docker image](https://hub.docker.com/_/ubuntu). The new image contains official package such as `nginx`, `php`, `graphicsmagick` and `imagemagick`, `sqlite3`, etc.

```bash
cd docker-ubuntu-nginx-php-typo3/
docker build --tag prototype .
```

Note that one step of the build process (`chown -Rh www-data: /var/www/typo3v13`) may take some time.

As part of the build process, Docker installs TYPO3 v13 LTS from scratch using a local [SQLite](https://www.sqlite.org) database engine.

## Run the Docker Container

The following command starts the Docker image as a new container named "typo3v13" and maps the local TCP port 8080 to port 80 of the container.

```bash
docker run --rm -it -d --name typo3v13 -p 8080:80 prototype
```

## Access TYPO3

You can now access the TYPO3 frontend at <http://localhost:8080>, and the TYPO3 backend at <http://localhost:8080/typo3/>.

- TYPO3 backend admin user name: `admin`
- TYPO3 backend admin password: `password`

## Important Security Note

This project is a simple **prototype** meant for demonstration and educational purposes. The configuration and hard-coded access credentials are insecure! DO NOT launch the Docker image in a publicly accessible environment unless you adjusted the configuration and took reasonable actions to secure the system.

## Data Retention Note

Note that the Docker container features a *local* SQLite database to store TYPO3's data, and a *local* `fileadmin/` directory. This setup does not support persistent data storage! Once you stop/remove a running container, you loose the data.

## Author

(c) 2024 Michael Schams [<schams.net>](https://schams.net)
