# Xray VLESS + WS on Abasthan (Free plan)

Abasthan Web Services deploy from Git only (no Go runtime, no Dockerfile /
Docker image option in the creation form). This repo runs Xray inside a
Node.js runtime slot: the build step downloads the pinned Xray release,
the start step writes the config from environment variables and runs it.

## Abasthan creation-form settings

- Source: Public Git Repository, this repo URL, branch `main`
- App Language: Node.js, Runtime Version 22
- Build Command:
  `curl -L -o xray.zip https://github.com/XTLS/Xray-core/releases/download/v26.10.31/Xray-linux-64.zip && (unzip -o xray.zip || python3 -c "import zipfile; zipfile.ZipFile('xray.zip').extractall()") && chmod +x xray && rm -f xray.zip`
- Start Command: `sh start.sh`
- Instance Type: Free (512 MB RAM, 0.1 vCPU, sleeps after inactivity)
- Environment Variables (set in the dashboard, never in this repo):
  - `UUID`: VLESS client id
  - `WS_PATH`: e.g. `/ws-xxxxxxxx`
  - `PORT` is injected by Abasthan; Xray listens on it directly.

TLS is terminated at the Abasthan / Cloudflare edge, so Xray itself uses
`security: none`. The client link uses `security=tls` for the
client-to-edge leg:

`vless://UUID@APP_DOMAIN:443?encryption=none&security=tls&type=ws&host=APP_DOMAIN&path=WS_PATH#abasthan-vless-ws`

## Known limits (verified 2026-11-16)

- WebSocket passthrough through `*.abasthan.app` is unverified in docs;
  verify with a WS handshake (expect HTTP 101) before relying on it.
- The Free instance sleeps after inactivity; a proxy that must stay up
  will wake on first request, with a cold-start delay.
- No `$3` welcome credit was present on the account checked ($0 balance).
