## 9. Third-party services

- **MUST:** Before depending on any free service, verify **today** that it needs no key and allows your usage. **[lesson]** Carto basemaps silently started returning "API KEY REQUIRED" watermark tiles (HTTP 200, 2 KB). Switched to **OpenFreeMap**.
- **MUST:** Check `res.ok` on every fetch; non-2xx is an error. Show a human message.
- **MUST:** Debounce + abort search-as-you-type (one request per pause, cancel stale ones).
- **MUST:** Respect usage policies (e.g. Nominatim: low rate, cache, attribute). Note: browsers can't set `User-Agent`; the `Referer` identifies you.
- **MUST:** Map/worker-based libraries: confirm their **worker files ship in the production build**. For MapLibre 6:
  ```ts
  import { setWorkerUrl } from 'maplibre-gl';
  import workerUrl from 'maplibre-gl/dist/maplibre-gl-worker.mjs?worker&url';
  setWorkerUrl(workerUrl);
  ```
- **MUST:** Don't gate your own content on a third party loading. **[lesson]** Trains and lines waited for the basemap's `load` event; offline or with a broken worker, the map showed nothing. Draw your layer immediately; the basemap is decoration.
- **SHOULD:** Silence harmless third-party warnings at the source (e.g. `map.setMissingStyleImageResolver` with a 1×1 transparent image) so the console stays a signal.

---
