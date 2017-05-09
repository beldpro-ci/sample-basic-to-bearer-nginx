CONTAINER_NAME 		:= nginx-lua-tests

# RUN is responsible for running our container.
# First it removes any prvevious  containers that
# were set up during testing, ignoring errors.
# Then, it runs a container using 
# openresty/opernresty:alpine-fat as the base image.
# It binds a volume with our nginx configuration and
# lua volumes so that we don't need to create a custom
# image and keep restarting the container.
run:
# create and  start the container
# mount current dir at /etc/nginx 
# bind to host's port 80
# name of the containerr
# base image
# start nginx with a specifiic config
	docker rm -f $(CONTAINER_NAME) || true
	docker run \
		-v $(shell pwd):/etc/nginx/ \
		-p 80:80 \
		--name $(CONTAINER_NAME) \
		openresty/openresty:alpine-fat \
		-c /etc/nginx/nginx.conf          


# Useful for reloading the nginx instance running inside
# the container. It simply executes a command inside the
# container that is running.
reload:
	docker exec \
		$(CONTAINER_NAME) \
		nginx -s reload


# Makes a request with the 'Basic' authorization header set.
# The header correesponds to 'Authorization: base64(user:pass)'
# The purpose here is to replace 'Basic base64(user:)' by 'Bearer user' 
test-basic-to-bearer: 
	@echo "Basic to Bearer"
	http -v :80/basic-to-bearer Authorization:'Basic dXNlcjpwYXNzCg=='


# Makes a request with the 'Bearer' authorization header.
# The purpose of this command is to verify that the endpoint ends up
# replacing 'Bearer token' by 'Basic base64(token:)'.
test-bearer-to-basic: 
	@echo "Bearer to Basic"
	http -v :80/bearer-to-basic Authorization:'Bearer token'


test: test-bearer-to-basic test-basic-to-bearer


.PHONY: run reload test
