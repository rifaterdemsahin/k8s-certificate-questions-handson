# Minimal web server deployed to Fly.io as the "deployed" counterpart of the
# minikube demo. Run >= 2 Machines so one can be restarted/migrated (drain analog)
# while the other keeps serving.
FROM nginx:1.27-alpine
RUN printf 'OK - k8s-cert-qa draining demo on Fly.io\n' > /usr/share/nginx/html/index.html
EXPOSE 8080
# Serve on 8080 to match fly.toml internal_port
RUN sed -i 's/listen       80;/listen       8080;/' /etc/nginx/conf.d/default.conf
