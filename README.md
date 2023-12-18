# Dockerfile
1. Отредактированы табы
2. Добавлена версия образа
3. ADD заменен на COPY
4. Переключение на юзера перенесено после его добавления и после выполнения команд требующего рут привелегий
5. unzip заменен на tar, так как добавляется архив .tar.gz
6. Удален пробел в пути /var/cache/apt/archives
7. WORKDIR перенесен в начало файла
8. apt заменен на apt-get
9. apt-get clean && rm -rf /var/cache/apt/archives и apt-get update && apt upgrade -y объеденены в один слой