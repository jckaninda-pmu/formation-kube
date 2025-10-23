FROM golang:1.25.2 AS build-stage
ENV GOPROXY=direct
ENV GOPRIVATE="gopkg.in"
ENV GOINSECURE="gopkg.in,github.com,proxy.golang.org,google.golang.org,golang.org,dario.cat,go.yaml.in"
ENV GOSUMDB=off

# Désactiver la vérification des certificats SSL
ENV GIT_SSL_NO_VERIFY=true
ENV GOFLAGS="-insecure"

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /main
EXPOSE 3000
CMD /main

FROM scratch
COPY --from=build-stage /main /main
COPY public/* ./public/
EXPOSE 3000
ENTRYPOINT ["/main"]