---
permalink: /siren-face-standalone/
layout: single
classes:
  - landing
  - dark-theme
sidebar:
  nav: "plugins_nav"
github_org: sirensolutions
github_repo: siren-arrow-java
toc: true
toc_sticky: true
toc_icon: "cog"
---

# Siren Face Standalone

Standalone, dockerized face analysis HTTP service using the same TFJS models as the Siren Investigate face plugin.

This service is intended to be called by other apps/services. It has no auth layer by default (run it behind your network controls).

## Endpoints

### Health

- `GET /healthz`
	- Always returns `200 {"status":"ok"}` if the process is running.

- `GET /readyz`
	- Returns `200 {"status":"ready"}` after models are loaded.
	- Returns `503 {"status":"starting"}` during startup/model load.

### Face analysis

#### `POST /v1/faces/analyze`

Accepts one image input via either:
- `multipart/form-data` with a file field named `image`
- JSON with `{ "url": "https://..." }`
- JSON with `{ "image_base64": "..." }`

##### Request options

These can be sent as JSON fields, or as multipart form fields:

- `minConfidence` (number, default `0.5`)
- `maxResults` (number, default `10`)
- `returnDescriptors` (boolean, default `true`)
- `returnCrops` (boolean, default `false`)
- `cropFormat` (`"jpg"` | `"png"`, default `"jpg"`)
- `cropPadding` (pixels, number, default `0`)

##### Response (200)

JSON:

- `source`: object describing the input (`url`, `file`, or `base64`)
- `faceCount`: number
- `faces[]`:
	- `box`: `{ x, y, width, height }`
	- `descriptor`: array of 128 floats (only if `returnDescriptors=true`)
	- `crop`: `{ contentType, base64 }` (only if `returnCrops=true`)

Example (trimmed):

```json
{
	"source": { "type": "url", "url": "https://example.com/image.jpg" },
	"faceCount": 1,
	"faces": [
		{
			"box": { "x": 123, "y": 45, "width": 67, "height": 67 },
			"descriptor": [0.01, -0.02, 0.03]
		}
	]
}
```

##### Error responses

- `400` when the image input is missing/invalid, or a URL fetch fails.
- `503` if models are not loaded yet.
- `500` on unexpected processing errors.

## Running

### Run locally (no Docker)

From this directory:

- `npm install`
- `npm start`

Service listens on `http://localhost:8080`.

### Docker: build & run

From repo root.

#### Universal image (recommended)

Build one image that can run fast (native TF) on AVX CPUs and fall back to WASM on older CPUs:

- `docker build -t siren-face-standalone:universal --build-arg INCLUDE_TFJS_NODE=true general/siren-face-standalone`

Run (publish host port 18080 → container 8080):

- `docker run -d --restart unless-stopped --name siren-face-standalone -e TF_MODE=auto -p 18080:8080 siren-face-standalone:universal`

If your host is known to be non-AVX, you may force compatibility mode:

- `docker run -d --restart unless-stopped --name siren-face-standalone -e TF_MODE=wasm -p 18080:8080 siren-face-standalone:universal`

#### Compatibility image (extra safety)

Build an image that removes `@tensorflow/tfjs-node` to avoid native TF crashes on non-AVX hosts:

- `docker build -t siren-face-standalone:compat --build-arg INCLUDE_TFJS_NODE=false general/siren-face-standalone`

Run:

- `docker run -d --restart unless-stopped --name siren-face-standalone -e TF_MODE=auto -p 18080:8080 siren-face-standalone:compat`

### Port mapping notes

- The service listens on container port `8080` by default.
- You can choose any host port using `-p <HOST_PORT>:8080`.
- Changing the internal container port is possible but not recommended because the Docker healthcheck assumes port 8080.

## Configuration

Environment variables:

- `TF_MODE`: `auto` (default) | `node` | `wasm`
	- `auto`: prefers native TF only if CPU exposes `avx` and `@tensorflow/tfjs-node` is available.
	- If the container exits with code `132` / "Illegal instruction", your host CPU/VM likely lacks `avx`; run with `TF_MODE=wasm` or use the compat image.
- `PORT` (default `8080`)
- `MODELS_DIR` (default `/app/models` in Docker)
- `CONCURRENCY` (default `1`)
- `LOG_LEVEL` (default `info`)
- `MAX_BYTES` (default `25MB`): max upload size
- `BODY_LIMIT` (default `60MB`): max JSON request size (base64 payloads)
- `LIMIT_INPUT_PIXELS` (default `50_000_000`): protects against huge images
- `MIN_CONFIDENCE` (default `0.5`)
- `MAX_RESULTS` (default `10`)

## Curl examples

URL input:

```bash
curl -sS -X POST http://127.0.0.1:18080/v1/faces/analyze \
	-H 'content-type: application/json' \
	-d '{"url":"https://example.com/image.jpg","returnCrops":false}'
```

Multipart file input (with crops):

```bash
curl -sS -X POST http://127.0.0.1:18080/v1/faces/analyze \
	-F 'image=@party.jpg' \
	-F 'returnCrops=true' \
	-F 'cropFormat=jpg' \
	-F 'cropPadding=10'
```

Base64 input:

```bash
base64 -w0 party.jpg \
	| jq -Rs '{image_base64: ., returnCrops: false}' \
	| curl -sS -X POST http://127.0.0.1:18080/v1/faces/analyze \
			-H 'content-type: application/json' \
			-d @-
```

## Troubleshooting

- Startup takes time: use `GET /readyz` to wait for model load.
- `Illegal instruction (core dumped)` / exit code `132`:
	- Your CPU/VM does not expose `avx`.
	- Use `-e TF_MODE=wasm` or deploy the compat image.
- Container is healthy but host curl fails:
	- Confirm you are curling the published host port (e.g. `18080` if you ran `-p 18080:8080`).
	- Confirm with `docker ps` and `docker port siren-face-standalone`.