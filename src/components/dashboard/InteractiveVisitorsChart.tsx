"use client";

import { useId, useMemo, useState } from "react";

type VisitorsPoint = {
  month: string;
  visitors: number;
};

type Point = {
  x: number;
  y: number;
};

const VISITORS_DATA: VisitorsPoint[] = [
  { month: "Jan", visitors: 9800 },
  { month: "Feb", visitors: 6800 },
  { month: "Mar", visitors: 4200 },
  { month: "Apr", visitors: 20100 },
  { month: "May", visitors: 16200 },
  { month: "Jun", visitors: 19100 },
  { month: "Jul", visitors: 7600 },
  { month: "Aug", visitors: 9400 },
  { month: "Sep", visitors: 28400 },
  { month: "Oct", visitors: 15700 },
  { month: "Nov", visitors: 19300 },
  { month: "Dec", visitors: 12400 },
];

const Y_TICKS = [0, 5000, 10000, 15000, 20000, 30000, 40000];

const SVG_WIDTH = 760;
const SVG_HEIGHT = 260;
const PADDING = { top: 14, right: 12, bottom: 16, left: 12 };

const clamp = (value: number, min: number, max: number) =>
  Math.min(Math.max(value, min), max);

const formatVisitors = (value: number) =>
  new Intl.NumberFormat("en-US").format(value);

const formatTick = (value: number) => (value === 0 ? "0" : `${value / 1000}k`);

const controlPoint = (
  current: Point,
  previous: Point,
  next: Point,
  reverse = false
): Point => {
  const prev = previous ?? current;
  const nxt = next ?? current;
  const smoothing = 0.18;
  const angle =
    Math.atan2(nxt.y - prev.y, nxt.x - prev.x) + (reverse ? Math.PI : 0);
  const length =
    Math.sqrt((nxt.x - prev.x) ** 2 + (nxt.y - prev.y) ** 2) * smoothing;

  return {
    x: current.x + Math.cos(angle) * length,
    y: current.y + Math.sin(angle) * length,
  };
};

const createSmoothPath = (points: Point[]): string => {
  if (!points.length) {
    return "";
  }

  return points.reduce((path, point, index) => {
    if (index === 0) {
      return `M ${point.x} ${point.y}`;
    }

    const previous = points[index - 1];
    const previousPrevious = points[index - 2] ?? previous;
    const next = points[index + 1] ?? point;
    const cp1 = controlPoint(previous, previousPrevious, point);
    const cp2 = controlPoint(point, previous, next, true);

    return `${path} C ${cp1.x} ${cp1.y}, ${cp2.x} ${cp2.y}, ${point.x} ${point.y}`;
  }, "");
};

export default function InteractiveVisitorsChart() {
  const [activeIndex, setActiveIndex] = useState<number>(8);
  const gradientId = useId().replace(/:/g, "");

  const maxY = Y_TICKS[Y_TICKS.length - 1];
  const chartBottom = SVG_HEIGHT - PADDING.bottom;
  const innerWidth = SVG_WIDTH - PADDING.left - PADDING.right;
  const innerHeight = chartBottom - PADDING.top;
  const stepX = innerWidth / (VISITORS_DATA.length - 1);

  const points = useMemo<Point[]>(
    () =>
      VISITORS_DATA.map((entry, index) => ({
        x: PADDING.left + stepX * index,
        y:
          PADDING.top +
          innerHeight * (1 - Math.min(entry.visitors / maxY, 1)),
      })),
    [innerHeight, maxY, stepX]
  );

  const linePath = useMemo(() => createSmoothPath(points), [points]);

  const areaPath = useMemo(() => {
    if (!points.length || !linePath) {
      return "";
    }

    const first = points[0];
    const last = points[points.length - 1];
    return `${linePath} L ${last.x} ${chartBottom} L ${first.x} ${chartBottom} Z`;
  }, [chartBottom, linePath, points]);

  const activePoint = points[activeIndex];
  const activeValue = VISITORS_DATA[activeIndex]?.visitors ?? 0;

  const updateActiveFromClientX = (
    clientX: number,
    target: EventTarget & SVGSVGElement
  ) => {
    const bounds = target.getBoundingClientRect();
    if (bounds.width <= 0) {
      return;
    }

    const relativeX = ((clientX - bounds.left) / bounds.width) * SVG_WIDTH;
    const clampedX = clamp(relativeX, PADDING.left, SVG_WIDTH - PADDING.right);
    const index = clamp(
      Math.round((clampedX - PADDING.left) / stepX),
      0,
      VISITORS_DATA.length - 1
    );
    setActiveIndex(index);
  };

  const tooltipX = activePoint ? clamp(activePoint.x, 72, SVG_WIDTH - 72) : 72;
  const tooltipY = activePoint
    ? clamp(activePoint.y - 40, 14, chartBottom - 10)
    : 20;

  return (
    <div className="overflow-hidden rounded-2xl border border-white/10 bg-[#3a3a3a] shadow-[0_16px_34px_-24px_rgba(0,0,0,0.9)]">
      <div className="flex min-h-[290px]">
        <div className="flex w-14 flex-col justify-between bg-[#f4a20f] px-2 py-4 text-sm font-semibold text-white">
          {[...Y_TICKS].reverse().map((tick) => (
            <span key={tick} className="leading-none">
              {formatTick(tick)}
            </span>
          ))}
        </div>

        <div className="flex-1 bg-[#464646] p-3">
          <div className="relative h-[220px]">
            <svg
              viewBox={`0 0 ${SVG_WIDTH} ${SVG_HEIGHT}`}
              className="h-full w-full"
              preserveAspectRatio="none"
              onPointerDown={(event) =>
                updateActiveFromClientX(event.clientX, event.currentTarget)
              }
              onPointerMove={(event) =>
                updateActiveFromClientX(event.clientX, event.currentTarget)
              }
              aria-label="Visitors chart"
              role="img"
            >
              <defs>
                <linearGradient
                  id={`${gradientId}-fill`}
                  x1="0"
                  y1="0"
                  x2="0"
                  y2="1"
                >
                  <stop offset="0%" stopColor="#ffb224" stopOpacity="1" />
                  <stop offset="100%" stopColor="#cc860f" stopOpacity="0.82" />
                </linearGradient>
              </defs>

              {Y_TICKS.filter((tick) => tick !== 0).map((tick) => {
                const y = PADDING.top + innerHeight * (1 - tick / maxY);
                return (
                  <line
                    key={tick}
                    x1={PADDING.left}
                    y1={y}
                    x2={SVG_WIDTH - PADDING.right}
                    y2={y}
                    stroke="rgba(255,255,255,0.18)"
                    strokeWidth={1}
                  />
                );
              })}

              <path d={areaPath} fill={`url(#${gradientId}-fill)`} />
              <path
                d={linePath}
                fill="none"
                stroke="#ffb20d"
                strokeWidth={2.4}
                strokeLinejoin="round"
                strokeLinecap="round"
              />

              {activePoint && (
                <>
                  <line
                    x1={activePoint.x}
                    y1={PADDING.top}
                    x2={activePoint.x}
                    y2={chartBottom}
                    stroke="rgba(255,255,255,0.82)"
                    strokeWidth={1.3}
                  />
                  <circle
                    cx={activePoint.x}
                    cy={activePoint.y}
                    r={5}
                    fill="#ffffff"
                    stroke="#f59e0b"
                    strokeWidth={2}
                  />
                </>
              )}
            </svg>

            {activePoint && (
              <div
                className="pointer-events-none absolute rounded-full bg-white px-3 py-1 text-[11px] font-semibold text-[#2b2b2b] shadow-[0_10px_16px_-12px_rgba(0,0,0,0.75)]"
                style={{
                  left: `${(tooltipX / SVG_WIDTH) * 100}%`,
                  top: `${(tooltipY / SVG_HEIGHT) * 100}%`,
                  transform: "translate(-50%, -100%)",
                }}
              >
                {formatVisitors(activeValue)} Visitor
              </div>
            )}
          </div>

          <div className="mt-2 grid grid-cols-12 gap-1 text-xs text-white/85">
            {VISITORS_DATA.map((entry, index) => {
              const isActive = activeIndex === index;
              return (
                <button
                  key={entry.month}
                  type="button"
                  onClick={() => setActiveIndex(index)}
                  className={`rounded px-0.5 py-0.5 text-center transition ${
                    isActive
                      ? "bg-white/10 font-semibold text-white"
                      : "text-white/80 hover:bg-white/5"
                  }`}
                >
                  {entry.month}
                </button>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
}
