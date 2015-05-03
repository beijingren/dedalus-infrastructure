#
# Celery container
#

docker kill celery
docker rm celery

docker run -d --privileged --name celery -p 5672:5672 -p 15672:15672 -v /docker:/docker:rw -t rabbitmq:latest
