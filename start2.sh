./rancher-compose --project-name sa-api-gateway \
--url http://192.168.99.100:8080/v1/projects/1a5 \
--access-key 9C3BD83FCDDBE8281555 \
--secret-key Xtopsp9Zxz6778Pw2r64mzAPrjLspRfRE8XKW5NR \
-f docker-compose.yml \
--verbose up \
-d --force-upgrade \
--confirm-upgrade
