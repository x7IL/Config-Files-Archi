server {
    listen 80; # Écoute sur le port 80 pour les connexions HTTP
    
    server_name vert.clement-g.com;

    # Racine du serveur pour la recherche de fichiers
    root /var/www/html/static/;

    # L'index.html par défaut de Nginx
    index index.php;

    location / {
        # Essaye de servir des fichiers statiques, sinon sert l'index.html
        try_files $uri $uri/ =404;
    }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;  # Ceci peut varier en fonction de la version de PHP et du système d'exploitation
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}

