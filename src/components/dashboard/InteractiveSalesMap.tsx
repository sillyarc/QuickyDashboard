"use client";

import { useEffect, useMemo, useRef, useState } from "react";

type SaleType = "taxi" | "drivers" | "clients";

type SalePin = {
  id: string;
  region: string;
  label: string;
  type: SaleType;
  lat: number;
  lon: number;
};

type Position = {
  x: number;
  y: number;
};

type Bounds = {
  minX: number;
  minY: number;
  maxX: number;
  maxY: number;
  width: number;
  height: number;
};

type Geometry = {
  type: string;
  coordinates: unknown;
};

type GeoFeature = {
  properties?: Record<string, unknown>;
  geometry?: Geometry;
};

type GeoJson = {
  features?: GeoFeature[];
};

type MapFeature = {
  key: string;
  name: string;
  path: string;
  center: Position;
  bounds: Bounds;
};

type MapPointFeature = {
  key: string;
  name: string;
  center: Position;
};

type LabelCandidate = {
  key: string;
  name: string;
  x: number;
  y: number;
  size: number;
  color: string;
  priority: number;
};

type DragState = {
  pointerX: number;
  pointerY: number;
  tx: number;
  ty: number;
};

type CameraState = {
  zoom: number;
  tx: number;
  ty: number;
};

const VIEWBOX_WIDTH = 1000;
const VIEWBOX_HEIGHT = 460;
const MIN_ZOOM = 1;

const MAP_SOURCES = {
  continents:
    "https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_50m_geography_regions_polys.geojson",
  countries:
    "https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_50m_admin_0_countries.geojson",
  states:
    "https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_50m_admin_1_states_provinces.geojson",
  cities:
    "https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_50m_populated_places_simple.geojson",
};

const SALE_TYPE_META: Record<SaleType, { label: string; color: string }> = {
  taxi: { label: "Taxi Drivers", color: "#fbb125" },
  drivers: { label: "Drivers", color: "#20b2ff" },
  clients: { label: "Clients", color: "#f73737" },
};

const SALE_PINS: SalePin[] = [
  {
    id: "na-west",
    region: "North America",
    label: "130 Sale",
    type: "taxi",
    lat: 37.7,
    lon: -122.4,
  },
  {
    id: "na-east",
    region: "North America",
    label: "302 Sale",
    type: "drivers",
    lat: 40.7,
    lon: -74.0,
  },
  {
    id: "eu-west",
    region: "Europe",
    label: "120 Sale",
    type: "clients",
    lat: 51.5,
    lon: -0.1,
  },
  {
    id: "africa-north",
    region: "Africa",
    label: "45 Sale",
    type: "drivers",
    lat: 30.0,
    lon: 31.2,
  },
  {
    id: "asia-east",
    region: "Asia",
    label: "79 Sale",
    type: "taxi",
    lat: 35.6,
    lon: 139.7,
  },
  {
    id: "australia-east",
    region: "Australia",
    label: "20 Sale",
    type: "clients",
    lat: -33.8,
    lon: 151.2,
  },
  {
    id: "oceania-south",
    region: "Oceania",
    label: "439 Sale",
    type: "taxi",
    lat: -18.1,
    lon: 178.4,
  },
  {
    id: "sa-east",
    region: "South America",
    label: "20 Sale",
    type: "clients",
    lat: -23.6,
    lon: -46.6,
  },
];

const clamp = (value: number, min: number, max: number) =>
  Math.min(Math.max(value, min), max);

const clampMinZoom = (value: number) => Math.max(value, MIN_ZOOM);

const titleCase = (value: string) =>
  value
    .toLowerCase()
    .replace(/_/g, " ")
    .replace(/\b\w/g, (char) => char.toUpperCase());

const lonLatToPoint = (lon: number, lat: number): Position => ({
  x: ((lon + 180) / 360) * VIEWBOX_WIDTH,
  y: ((90 - lat) / 180) * VIEWBOX_HEIGHT,
});

const asNumber = (value: unknown) =>
  typeof value === "number" && Number.isFinite(value) ? value : null;

const extractPoints = (coords: unknown, acc: Position[]) => {
  if (!Array.isArray(coords)) {
    return;
  }

  if (
    coords.length >= 2 &&
    typeof coords[0] === "number" &&
    typeof coords[1] === "number"
  ) {
    const lon = asNumber(coords[0]);
    const lat = asNumber(coords[1]);
    if (lon !== null && lat !== null) {
      acc.push(lonLatToPoint(lon, lat));
    }
    return;
  }

  for (const item of coords) {
    extractPoints(item, acc);
  }
};

const geometryToPath = (geometry?: Geometry): string => {
  if (!geometry || !geometry.coordinates) {
    return "";
  }

  const buildRing = (ring: unknown): string => {
    const ringPoints: Position[] = [];
    extractPoints(ring, ringPoints);
    if (!ringPoints.length) {
      return "";
    }
    const start = ringPoints[0];
    const lines = ringPoints.slice(1).map((point) => `L${point.x} ${point.y}`);
    return `M${start.x} ${start.y}${lines.join("")}Z`;
  };

  if (geometry.type === "Polygon") {
    const rings = (geometry.coordinates as unknown[]) ?? [];
    return rings.map(buildRing).join("");
  }

  if (geometry.type === "MultiPolygon") {
    const polys = (geometry.coordinates as unknown[]) ?? [];
    return polys
      .map((poly) => ((poly as unknown[]) ?? []).map(buildRing).join(""))
      .join("");
  }

  if (geometry.type === "MultiLineString") {
    const lines = (geometry.coordinates as unknown[]) ?? [];
    return lines
      .map((line) => {
        const linePoints: Position[] = [];
        extractPoints(line, linePoints);
        if (!linePoints.length) {
          return "";
        }
        const start = linePoints[0];
        const segments = linePoints
          .slice(1)
          .map((point) => `L${point.x} ${point.y}`)
          .join("");
        return `M${start.x} ${start.y}${segments}`;
      })
      .join("");
  }

  return "";
};

const geometryMetrics = (geometry?: Geometry): { center: Position; bounds: Bounds } | null => {
  if (!geometry) {
    return null;
  }

  const points: Position[] = [];
  extractPoints(geometry.coordinates, points);
  if (!points.length) {
    return null;
  }

  let minX = Number.POSITIVE_INFINITY;
  let minY = Number.POSITIVE_INFINITY;
  let maxX = Number.NEGATIVE_INFINITY;
  let maxY = Number.NEGATIVE_INFINITY;

  for (const point of points) {
    minX = Math.min(minX, point.x);
    minY = Math.min(minY, point.y);
    maxX = Math.max(maxX, point.x);
    maxY = Math.max(maxY, point.y);
  }

  return {
    center: {
      x: (minX + maxX) / 2,
      y: (minY + maxY) / 2,
    },
    bounds: {
      minX,
      minY,
      maxX,
      maxY,
      width: Math.max(0.01, maxX - minX),
      height: Math.max(0.01, maxY - minY),
    },
  };
};

const mapFeatures = (
  features: GeoFeature[],
  options: {
    filter?: (feature: GeoFeature) => boolean;
    getName: (feature: GeoFeature, index: number) => string;
  }
) =>
  features
    .filter((feature) => (options.filter ? options.filter(feature) : true))
    .map((feature, index) => {
      const metrics = geometryMetrics(feature.geometry);
      const path = geometryToPath(feature.geometry);
      if (!metrics || !path) {
        return null;
      }
      return {
        key: `${index}-${options.getName(feature, index)}`,
        name: options.getName(feature, index),
        path,
        center: metrics.center,
        bounds: metrics.bounds,
      } satisfies MapFeature;
    })
    .filter((feature): feature is MapFeature => feature !== null);

const mapPointFeatures = (
  features: GeoFeature[],
  options: {
    filter?: (feature: GeoFeature) => boolean;
    getName: (feature: GeoFeature, index: number) => string;
  }
) =>
  features
    .filter((feature) => (options.filter ? options.filter(feature) : true))
    .map((feature, index) => {
      const coords = feature.geometry?.coordinates;
      if (
        feature.geometry?.type !== "Point" ||
        !Array.isArray(coords) ||
        coords.length < 2
      ) {
        return null;
      }
      const lon = asNumber(coords[0]);
      const lat = asNumber(coords[1]);
      if (lon === null || lat === null) {
        return null;
      }
      return {
        key: `${index}-${options.getName(feature, index)}`,
        name: options.getName(feature, index),
        center: lonLatToPoint(lon, lat),
      } satisfies MapPointFeature;
    })
    .filter((feature): feature is MapPointFeature => feature !== null);

const isContinentFeature = (feature: GeoFeature) => {
  const type = String(feature.properties?.FEATURECLA ?? "");
  return type.toLowerCase() === "continent";
};

const sizeFromBounds = (
  name: string,
  bounds: Bounds,
  minSize: number,
  maxSize: number
) => {
  const chars = Math.max(name.length, 3);
  const widthFit = (bounds.width * 0.9) / (chars * 0.62);
  const heightFit = bounds.height * 0.42;
  return clamp(Math.min(widthFit, heightFit), minSize, maxSize);
};

const sizeFromName = (
  name: string,
  minSize: number,
  maxSize: number,
  base = 0.85
) => {
  const factor = Math.sqrt(6 / Math.max(name.length, 3));
  return clamp(base * factor, minSize, maxSize);
};

const estimateLabelBox = (label: LabelCandidate) => {
  const width = label.name.length * label.size * 0.63 + label.size * 0.9;
  const height = label.size * 1.3;
  return {
    left: label.x - width / 2,
    right: label.x + width / 2,
    top: label.y - height * 0.72,
    bottom: label.y + height * 0.28,
  };
};

const intersects = (
  a: ReturnType<typeof estimateLabelBox>,
  b: ReturnType<typeof estimateLabelBox>,
  padding = 0.8
) =>
  !(
    a.right + padding < b.left ||
    a.left > b.right + padding ||
    a.bottom + padding < b.top ||
    a.top > b.bottom + padding
  );

export default function InteractiveSalesMap() {
  const mapSurfaceRef = useRef<HTMLDivElement | null>(null);
  const [activePinId, setActivePinId] = useState<string>(SALE_PINS[1].id);
  const [continents, setContinents] = useState<GeoFeature[]>([]);
  const [countries, setCountries] = useState<GeoFeature[]>([]);
  const [states, setStates] = useState<GeoFeature[]>([]);
  const [cities, setCities] = useState<GeoFeature[]>([]);
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [camera, setCamera] = useState<CameraState>({
    zoom: 1.08,
    tx: 0,
    ty: 0,
  });
  const [drag, setDrag] = useState<DragState | null>(null);

  const clampCamera = (targetZoom: number, tx: number, ty: number): CameraState => {
    const maxTx = 0;
    const maxTy = 0;
    const minTx = VIEWBOX_WIDTH - VIEWBOX_WIDTH * targetZoom;
    const minTy = VIEWBOX_HEIGHT - VIEWBOX_HEIGHT * targetZoom;
    return {
      zoom: targetZoom,
      tx: clamp(tx, minTx, maxTx),
      ty: clamp(ty, minTy, maxTy),
    };
  };

  useEffect(() => {
    const controller = new AbortController();

    const load = async () => {
      try {
        setIsLoading(true);
        const [continentsRes, countriesRes, statesRes, citiesRes] =
          await Promise.all([
            fetch(MAP_SOURCES.continents, { signal: controller.signal }),
            fetch(MAP_SOURCES.countries, { signal: controller.signal }),
            fetch(MAP_SOURCES.states, { signal: controller.signal }),
            fetch(MAP_SOURCES.cities, { signal: controller.signal }),
          ]);

        const [continentsData, countriesData, statesData, citiesData] =
          (await Promise.all([
            continentsRes.json(),
            countriesRes.json(),
            statesRes.json(),
            citiesRes.json(),
          ])) as [GeoJson, GeoJson, GeoJson, GeoJson];

        setContinents(continentsData.features ?? []);
        setCountries(countriesData.features ?? []);
        setStates(statesData.features ?? []);
        setCities(citiesData.features ?? []);
      } catch {
        setContinents([]);
        setCountries([]);
        setStates([]);
        setCities([]);
      } finally {
        setIsLoading(false);
      }
    };

    load();
    return () => controller.abort();
  }, []);

  const continentFeatures = useMemo(
    () =>
      mapFeatures(continents, {
        filter: isContinentFeature,
        getName: (feature, index) =>
          titleCase(String(feature.properties?.NAME ?? `Continent ${index + 1}`)),
      }),
    [continents]
  );

  const countryFeatures = useMemo(
    () =>
      mapFeatures(countries, {
        getName: (feature, index) =>
          titleCase(
            String(
              feature.properties?.NAME ??
                feature.properties?.ADMIN ??
                `Country ${index + 1}`
            )
          ),
      }),
    [countries]
  );

  const stateFeatures = useMemo(
    () =>
      mapFeatures(states, {
        getName: (feature, index) =>
          titleCase(
            String(
              feature.properties?.name ??
                feature.properties?.name_en ??
                `State ${index + 1}`
            )
          ),
      }),
    [states]
  );

  const cityFeatures = useMemo(
    () =>
      mapPointFeatures(cities, {
        getName: (feature, index) =>
          titleCase(
            String(
              feature.properties?.name ??
                feature.properties?.nameascii ??
                `City ${index + 1}`
            )
          ),
        filter: (feature) => {
          const scalerank = asNumber(feature.properties?.scalerank ?? null);
          return scalerank === null || scalerank <= 4;
        },
      }),
    [cities]
  );

  const activePin = useMemo(
    () => SALE_PINS.find((pin) => pin.id === activePinId) ?? SALE_PINS[0],
    [activePinId]
  );

  const applyZoom = (
    targetZoom: number,
    centerX = VIEWBOX_WIDTH / 2,
    centerY = VIEWBOX_HEIGHT / 2
  ) => {
    setCamera((previous) => {
      const nextZoom = clampMinZoom(targetZoom);
      const ratio = nextZoom / previous.zoom;
      const nextTx = centerX - (centerX - previous.tx) * ratio;
      const nextTy = centerY - (centerY - previous.ty) * ratio;
      return clampCamera(nextZoom, nextTx, nextTy);
    });
  };

  const handleWheel: React.WheelEventHandler<HTMLDivElement> = (event) => {
    event.preventDefault();
    event.stopPropagation();
    const bounds = event.currentTarget.getBoundingClientRect();
    const cursorX = ((event.clientX - bounds.left) / bounds.width) * VIEWBOX_WIDTH;
    const cursorY = ((event.clientY - bounds.top) / bounds.height) * VIEWBOX_HEIGHT;
    setCamera((previous) => {
      const nextZoom = clampMinZoom(
        previous.zoom * (event.deltaY < 0 ? 1.16 : 0.86)
      );
      const ratio = nextZoom / previous.zoom;
      const nextTx = cursorX - (cursorX - previous.tx) * ratio;
      const nextTy = cursorY - (cursorY - previous.ty) * ratio;
      return clampCamera(nextZoom, nextTx, nextTy);
    });
  };

  const handlePointerDown: React.PointerEventHandler<HTMLDivElement> = (
    event
  ) => {
    event.preventDefault();
    const target = event.target as HTMLElement;
    if (target.closest("button")) {
      return;
    }
    (event.currentTarget as HTMLDivElement).setPointerCapture(event.pointerId);
    setDrag({
      pointerX: event.clientX,
      pointerY: event.clientY,
      tx: camera.tx,
      ty: camera.ty,
    });
  };

  const handlePointerMove: React.PointerEventHandler<HTMLDivElement> = (
    event
  ) => {
    if (!drag || !mapSurfaceRef.current) {
      return;
    }
    event.preventDefault();
    const bounds = mapSurfaceRef.current.getBoundingClientRect();
    const dx = ((event.clientX - drag.pointerX) / bounds.width) * VIEWBOX_WIDTH;
    const dy = ((event.clientY - drag.pointerY) / bounds.height) * VIEWBOX_HEIGHT;
    const clamped = clampCamera(camera.zoom, drag.tx + dx, drag.ty + dy);
    setCamera(clamped);
  };

  const handlePointerUp: React.PointerEventHandler<HTMLDivElement> = (
    event
  ) => {
    try {
      (event.currentTarget as HTMLDivElement).releasePointerCapture(
        event.pointerId
      );
    } catch {}
    setDrag(null);
  };

  const stopPointer: React.PointerEventHandler<HTMLButtonElement> = (event) => {
    event.stopPropagation();
  };

  const showCountryLabels = camera.zoom >= 1.75;
  const showStateLabels = camera.zoom >= 2.6;
  const showCityLabels = camera.zoom >= 3.4;

  const visibleLabels = useMemo(() => {
    const candidates: LabelCandidate[] = [];

    for (const feature of continentFeatures) {
      candidates.push({
        key: `continent-label-${feature.key}`,
        name: feature.name,
        x: feature.center.x,
        y: feature.center.y,
        size: sizeFromBounds(feature.name, feature.bounds, 0.6, 1.2),
        color: "rgba(255,255,255,0.88)",
        priority: 1,
      });
    }

    if (showCountryLabels) {
      for (const feature of countryFeatures) {
        candidates.push({
          key: `country-label-${feature.key}`,
          name: feature.name,
          x: feature.center.x,
          y: feature.center.y,
          size: sizeFromBounds(feature.name, feature.bounds, 0.28, 0.85),
          color: "rgba(255,255,255,0.8)",
          priority: 2,
        });
      }
    }

    if (showStateLabels) {
      for (const feature of stateFeatures) {
        candidates.push({
          key: `state-label-${feature.key}`,
          name: feature.name,
          x: feature.center.x,
          y: feature.center.y,
          size: sizeFromBounds(feature.name, feature.bounds, 0.22, 0.62),
          color: "rgba(255,255,255,0.68)",
          priority: 3,
        });
      }
    }

    if (showCityLabels) {
      for (const feature of cityFeatures) {
        candidates.push({
          key: `city-label-${feature.key}`,
          name: feature.name,
          x: feature.center.x,
          y: feature.center.y,
          size: sizeFromName(feature.name, 0.2, 0.44, 0.42),
          color: "rgba(255,255,255,0.6)",
          priority: 4,
        });
      }
    }

    candidates.sort((a, b) => {
      if (a.priority !== b.priority) {
        return a.priority - b.priority;
      }
      return b.size - a.size;
    });

    const placed: ReturnType<typeof estimateLabelBox>[] = [];
    const output: LabelCandidate[] = [];

    for (const candidate of candidates) {
      const box = estimateLabelBox(candidate);
      const collides = placed.some((existing) => intersects(box, existing));
      if (collides) {
        continue;
      }
      placed.push(box);
      output.push(candidate);
    }

    return output;
  }, [
    cityFeatures,
    continentFeatures,
    countryFeatures,
    showCityLabels,
    showCountryLabels,
    showStateLabels,
    stateFeatures,
  ]);

  return (
    <div className="rounded-2xl border border-white/10 bg-[#1e1e1e] p-4">
      <div className="flex items-center justify-between gap-3">
        <p className="text-sm font-semibold text-white">Sale Map</p>
        <span className="rounded-full border border-white/10 bg-[#111111] px-3 py-1 text-[11px] text-white/85">
          {activePin.region} - {activePin.label}
        </span>
      </div>

      <div
        ref={mapSurfaceRef}
        className="relative mt-3 h-[260px] touch-none overscroll-contain overflow-hidden rounded-xl border border-white/10 bg-[#131313]"
        onWheel={handleWheel}
        onPointerDown={handlePointerDown}
        onPointerMove={handlePointerMove}
        onPointerUp={handlePointerUp}
        onPointerCancel={handlePointerUp}
      >
        {isLoading && (
          <div className="absolute inset-0 z-20 grid place-items-center bg-[#101010]/80 text-xs text-white/80">
            Carregando mapa...
          </div>
        )}

        <svg
          viewBox={`0 0 ${VIEWBOX_WIDTH} ${VIEWBOX_HEIGHT}`}
          className="h-full w-full"
          preserveAspectRatio="none"
          aria-label="Mapa interativo de vendas"
          role="img"
        >
          <g transform={`matrix(${camera.zoom} 0 0 ${camera.zoom} ${camera.tx} ${camera.ty})`}>
            {continentFeatures.map((feature) => (
              <path
                key={`continent-${feature.key}`}
                d={feature.path}
                fill="#363636"
                stroke="rgba(255,255,255,0.5)"
                strokeWidth={0.17}
              />
            ))}

            {countryFeatures.map((feature) => (
              <path
                key={`country-${feature.key}`}
                d={feature.path}
                fill="transparent"
                stroke="rgba(255,255,255,0.75)"
                strokeWidth={0.065}
              />
            ))}

            {stateFeatures.map((feature) => (
              <path
                key={`state-${feature.key}`}
                d={feature.path}
                fill="transparent"
                stroke="rgba(255,255,255,0.52)"
                strokeWidth={0.045}
              />
            ))}

            {visibleLabels.map((label) => (
              <text
                key={label.key}
                x={label.x}
                y={label.y}
                textAnchor="middle"
                fontSize={label.size}
                fill={label.color}
                fontFamily="var(--font-display), 'Poppins', sans-serif"
                fontWeight={100}
                fontStretch="condensed"
                pointerEvents="none"
              >
                {label.name}
              </text>
            ))}

            {SALE_PINS.map((pin) => {
              const meta = SALE_TYPE_META[pin.type];
              const center = lonLatToPoint(pin.lon, pin.lat);
              const width = pin.label.length * 4.8 + 15;
              const isActive = pin.id === activePinId;
              return (
                <g
                  key={pin.id}
                  transform={`translate(${center.x} ${center.y})`}
                  onClick={() => setActivePinId(pin.id)}
                  style={{ cursor: "pointer" }}
                >
                  <rect
                    x={0}
                    y={0}
                    width={width}
                    height={12}
                    rx={3}
                    fill={isActive ? "#080808" : "#161616"}
                    stroke={isActive ? "rgba(255,255,255,0.35)" : "rgba(255,255,255,0.12)"}
                    strokeWidth={0.35}
                  />
                  <rect
                    x={3.5}
                    y={3.6}
                    width={4.2}
                    height={4.2}
                    rx={0.9}
                    fill={meta.color}
                  />
                  <text
                    x={9.2}
                    y={8.35}
                    fontSize={5.6}
                    fontWeight={700}
                    fill="white"
                  >
                    {pin.label}
                  </text>
                </g>
              );
            })}
          </g>
        </svg>

        <div className="absolute bottom-3 right-3 z-30 flex items-center gap-2">
            <button
              type="button"
              onPointerDown={stopPointer}
              onClick={(event) => {
                event.stopPropagation();
                applyZoom(camera.zoom + 0.35);
              }}
              className="grid h-7 w-7 place-items-center rounded border border-white/15 bg-[#0f0f0f]/95 text-sm text-white/90 transition hover:border-white/35"
              aria-label="Aumentar zoom"
            >
            +
          </button>
            <button
              type="button"
              onPointerDown={stopPointer}
              onClick={(event) => {
                event.stopPropagation();
                applyZoom(camera.zoom - 0.35);
              }}
              className="grid h-7 w-7 place-items-center rounded border border-white/15 bg-[#0f0f0f]/95 text-sm text-white/90 transition hover:border-white/35"
              aria-label="Diminuir zoom"
            >
            -
          </button>
            <button
              type="button"
              onPointerDown={stopPointer}
              onClick={(event) => {
                event.stopPropagation();
                setCamera({
                  zoom: 1.08,
                  tx: 0,
                  ty: 0,
                });
              }}
              className="rounded border border-white/15 bg-[#0f0f0f]/95 px-2 py-1 text-[10px] text-white/90 transition hover:border-white/35"
            >
            Reset
          </button>
        </div>
      </div>

      <div className="mt-4 flex flex-wrap items-center justify-between gap-2 rounded-lg border border-white/10 bg-[#141414] px-3 py-2 text-[11px] text-white/80">
        <div className="flex flex-wrap items-center gap-x-5 gap-y-2">
          {(Object.keys(SALE_TYPE_META) as SaleType[]).map((type) => {
            const meta = SALE_TYPE_META[type];
            return (
              <div key={type} className="inline-flex items-center gap-2">
                <span
                  className="inline-flex h-2.5 w-2.5 rounded-[2px]"
                  style={{ backgroundColor: meta.color }}
                />
                <span>{meta.label}</span>
              </div>
            );
          })}
        </div>
        <span className="text-[10px] text-white/60">
          Zoom para ver labels: paises, estados e cidades
        </span>
      </div>
    </div>
  );
}
