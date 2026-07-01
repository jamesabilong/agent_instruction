# Portfolio Deployment And Local Operations

Last investigated: 2026-07-01

## Local Development

```sh
cd jamesabilong
npm install
npm run dev
```

## Build And Preview

```sh
cd jamesabilong
npm run build
npm run preview
```

## Deployment Notes

- Production Docker config exists in `jamesabilong/Dockerfile.prod` and `jamesabilong/docker-compose.prod.yml`.
- nginx templates/configs and VPS deploy script live under `jamesabilong/deploy`.
- Resume assets live under `jamesabilong/public/resume`.

## Verification Checklist

- Run `npm run build` for production-sensitive changes.
- Manually review routed pages after content or navigation changes.
