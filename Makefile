CONTAINER_NAME 		:= nginx-lua-tests

run:
	docker rm -f $(CONTAINER_NAME) || true
	docker run \
		-v $(shell pwd):/etc/nginx/ \
		-p 80:80 \
		--name $(CONTAINER_NAME) \
		openresty/openresty:alpine-fat \
		-c /etc/nginx/nginx.conf

reload:
	docker exec \
		$(CONTAINER_NAME) \
		nginx -s reload

test-basic-to-bearer: 
	@echo "Basic to Bearer"
	http -v :80/basic-to-bearer Authorization:'Basic dXNlcjpwYXNzCg=='

test-bearer-to-basic: 
	@echo "Bearer to Basic"
	http -v :80/bearer-to-basic Authorization:'Bearer token'


test: test-bearer-to-basic test-basic-to-bearer

.PHONY: run reload test
