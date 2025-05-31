docker pull container-registry.oracle.com/database/adb-free:latest-23ai
docker run -d \
-p 1521:1522 \
-p 1522:1522 \
-p 8443:8443 \
-p 27017:27017 \
-e WORKLOAD_TYPE='ATP' \
-e WALLET_PASSWORD='' \
-e ADMIN_PASSWORD='' \
--cap-add SYS_ADMIN \
--device /dev/fuse \
--name adb-free \
container-registry.oracle.com/database/adb-free:latest-23ai

alias adb-cli="docker exec adb-free adb-cli"
https://localhost:8443/ords/sql-developer # log in to ADB