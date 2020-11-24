Docker LAMP:
+ Apache: 2.4.3
+ MYSQL: 5.0
+ PHP: 5.2


#RUN DOCKER:

```
docker run -itd -h lampd -p 80:80 -p 3306:3306 \
                -v ${PWD}/data/conf_apache2:/usr/local/apache2/ \
                -v ${PWD}/data/conf_php:/usr/local/php/ \
                -v ${PWD}/data/conf_mysql:/usr/local/mysql/ \
                -v ${PWD}/data/data_mysql:/home/MYSQL/data \
                -v ${PWD}/data/data_apache2:/usr/local/apache2/htdocs \
                -v ${PWD}/data/log_apache2:/usr/local/apache2/logs \
                -v ${PWD}/data/log_mysql:/home/MYSQL/log \
                --name lampd lampd
```

================================

default password mysql: lamplamp

================================

Check status:

```docker exec lampd /status.sh```

Enter bash:

``` docker exec -it lampd bash```
