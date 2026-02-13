"use client";

import Link from "next/link";
import { ensureFirebaseAuthSession, getFirebaseDb } from "@/lib/firebase/client";
import { divIcon } from "leaflet";
import { useMemo, useState } from "react";
import { addDoc, collection, serverTimestamp } from "firebase/firestore";
import {
  MapContainer,
  Marker,
  Popup,
  TileLayer,
  ZoomControl,
  useMapEvents,
} from "react-leaflet";

type MarkerKind = "passenger" | "driver" | "sos_passenger" | "threat_driver";

type WorldMarker = {
  id: string;
  kind: MarkerKind;
  name: string;
  role: string;
  lat: number;
  lng: number;
  rating?: number;
  location?: string;
  rides?: string;
  passport?: string;
  age?: string;
  gender?: string;
  vehicle?: string;
  ridesMonth?: string;
  ridesTotal?: string;
  status?: string;
  phone?: string;
  contactName?: string;
  contactRole?: string;
  contactPhone?: string;
  ethnicity?: string;
  emergencyContact?: string;
  plate?: string;
  message?: string;
};

const topNavLinks = [
  { label: "Dashboard", href: "/quickysolutionsllcdashboard" },
  { label: "Disputes & Expense", href: "/disputes-expense" },
  { label: "Dispute Resolution", href: "/edittask" },
  { label: "Flow Builder, Campaigns & Rewards", href: "/flow-builder-campaigns-rewards" },
  { label: "Users", href: "/users" },
  { label: "map", href: "/map" },
];

const MAP_MARKERS: WorldMarker[] = [
  {
    id: "passenger-enzo",
    kind: "passenger",
    name: "Enzo Godoy",
    role: "Rider",
    lat: 25.048,
    lng: -77.355,
    rating: 4,
    location: "United States, Florida",
    rides: "30",
    passport: "GB882306",
    age: "19",
    gender: "Female",
    contactName: "Sam Miller",
    contactRole: "Taxi Driver",
    contactPhone: "+13055550199",
  },
  {
    id: "driver-sam",
    kind: "driver",
    name: "Sam Miller",
    role: "Taxi Driver",
    lat: 25.044,
    lng: -77.347,
    rating: 4,
    vehicle: "Nissan Serena",
    ridesMonth: "132",
    ridesTotal: "400",
    status: "Available",
    phone: "+13055550199",
  },
  {
    id: "sos-passenger-giulia",
    kind: "sos_passenger",
    name: "Giulia Bader",
    role: "Not in a Ride",
    lat: 25.035,
    lng: -77.381,
    gender: "Female",
    location: "United States, Florida",
    ethnicity: "White",
    emergencyContact: "Mari [Mom]: (305) 850-0987",
    passport: "GB882306",
  },
  {
    id: "threat-joe",
    kind: "threat_driver",
    name: "Joe Messina",
    role: "Taxi Driver",
    lat: 25.046,
    lng: -77.319,
    plate: "#EAD199",
    message:
      "Rider Requested Help! Please he has a gun! And we are not going in the direction of the maps... cannot talk.",
    phone: "+13055550100",
  },
  {
    id: "driver-london",
    kind: "driver",
    name: "Emma Clark",
    role: "Local Driver",
    lat: 51.5072,
    lng: -0.1276,
    rating: 5,
    vehicle: "Toyota Prius",
    ridesMonth: "89",
    ridesTotal: "1210",
    status: "Available",
    phone: "+442071234567",
  },
  {
    id: "driver-tokyo",
    kind: "driver",
    name: "Kenji Sato",
    role: "Taxi Driver",
    lat: 35.6764,
    lng: 139.65,
    rating: 4,
    vehicle: "Toyota Sienta",
    ridesMonth: "104",
    ridesTotal: "980",
    status: "In ride",
    phone: "+81312345678",
  },
  {
    id: "passenger-sao-paulo",
    kind: "passenger",
    name: "Mariana Costa",
    role: "Rider",
    lat: -23.5505,
    lng: -46.6333,
    rating: 4,
    location: "Sao Paulo, Brazil",
    rides: "87",
    passport: "BR773920",
    age: "29",
    gender: "Female",
    contactName: "Carlos Silva",
    contactRole: "Driver",
    contactPhone: "+5511999988877",
  },
];

const buildChatRoute = (name: string, role: string) =>
  `/profile-chat?name=${encodeURIComponent(name)}&role=${encodeURIComponent(role)}`;

const firstName = (fullName: string) =>
  fullName
    .trim()
    .split(/\s+/)
    .filter(Boolean)[0] ?? fullName;

const ratingStars = (count = 4) =>
  Array.from({ length: 5 }).map((_, index) => (
    <svg
      key={`star-${index}`}
      viewBox="0 0 20 20"
      className="h-4 w-4"
      fill={index < count ? "#f4a20f" : "#8f8f8f"}
      aria-hidden="true"
    >
      <path d="m10 1.7 2.3 4.75 5.24.76-3.8 3.7.9 5.22L10 13.84l-4.64 2.3.9-5.22-3.8-3.7 5.24-.76L10 1.7Z" />
    </svg>
  ));

const carSvg = (body: string) =>
  `<svg viewBox="0 0 44 24" xmlns="http://www.w3.org/2000/svg"><path d="M5 10.8 10 4h18l6 6.8h4.5v6.4H35a3.4 3.4 0 0 1-6.8 0H15.8a3.4 3.4 0 0 1-6.8 0H5v-6.4Z" fill="${body}" stroke="#111" stroke-width="1.2"/><circle cx="12.4" cy="17.2" r="2.5" fill="#121212"/><circle cx="31.6" cy="17.2" r="2.5" fill="#121212"/></svg>`;

const personSvg = (body: string, stroke: string) =>
  `<svg viewBox="0 0 34 40" xmlns="http://www.w3.org/2000/svg"><circle cx="17" cy="12" r="8.5" fill="${body}" stroke="${stroke}" stroke-width="1.5"/><path d="M8.2 36.8c1.5-5.7 4.9-8.6 8.8-8.6 4 0 7.3 2.9 8.8 8.6" fill="${body}" stroke="${stroke}" stroke-width="1.5"/></svg>`;

const createDivIcon = (svg: string, width: number, height: number) =>
  divIcon({
    className: "qd-map-marker",
    html: `<span class="qd-map-marker__inner" style="width:${width}px;height:${height}px">${svg}</span>`,
    iconSize: [width, height],
    iconAnchor: [width / 2, height / 2],
    popupAnchor: [0, -Math.max(18, height / 2)],
  });

function PopupReset({ onReset }: { onReset: () => void }) {
  useMapEvents({
    click: () => onReset(),
  });
  return null;
}

type MapActionCallback = (
  marker: WorldMarker,
  action: string,
  metadata?: Record<string, unknown>
) => void;

const renderPopupContent = (marker: WorldMarker, onAction: MapActionCallback) => {
  const userLocationHref = `https://www.google.com/maps?q=${marker.lat},${marker.lng}`;

  if (marker.kind === "passenger") {
    const contactName = marker.contactName ?? marker.name;
    const contactRole = marker.contactRole ?? "Driver";
    const contactPhone = marker.contactPhone ?? marker.phone ?? "";
    const contactFirstName = firstName(contactName);

    return (
      <article className="w-[300px] rounded-[18px] border border-white/10 bg-[#252525]/95 p-4 text-white shadow-[0_20px_36px_-20px_rgba(0,0,0,0.85)] backdrop-blur-sm">
        <div className="flex items-start justify-between gap-2">
          <div>
            <p className="text-[36px] font-semibold italic leading-none">{marker.name}</p>
            <p className="mt-1 text-[42px] font-semibold leading-none">Rider Rating:</p>
          </div>
          <span className="inline-flex h-6 w-6 items-center justify-center rounded-full bg-[#f4a20f] text-[10px] font-bold text-black">
            !
          </span>
        </div>
        <div className="mt-1 flex items-center gap-1">{ratingStars(marker.rating ?? 4)}</div>
        <div className="mt-2 space-y-1 text-[14px] font-semibold italic">
          <p className="rounded-full border border-white/10 bg-[#1b1b1b] px-3 py-1 text-[#d2d2d2]">
            Where From {marker.location ?? "Unknown"}
          </p>
          <p className="rounded-full border border-white/10 bg-[#1b1b1b] px-3 py-1 text-[#d2d2d2]">
            # of Rides: {marker.rides ?? "-"} Passport #: {marker.passport ?? "-"}
          </p>
          <p className="rounded-full border border-white/10 bg-[#1b1b1b] px-3 py-1 text-[#d2d2d2]">
            Age: {marker.age ?? "-"} Gender: {marker.gender ?? "-"}
          </p>
        </div>
        <div className="mt-3 flex items-center gap-2 text-[36px] font-semibold italic leading-none">
          <Link
            href={buildChatRoute(contactName, contactRole)}
            onClick={() =>
              onAction(marker, "text_contact", {
                contactName,
                contactRole,
                contactPhone,
              })
            }
            className="rounded-full bg-[#1b1b1b] px-5 py-2 text-white transition hover:bg-[#2a2a2a]"
          >
            Text {contactFirstName}
          </Link>
          <a
            href={contactPhone ? `tel:${contactPhone}` : "#"}
            onClick={() =>
              onAction(marker, "call_contact", {
                contactName,
                contactRole,
                contactPhone,
              })
            }
            className="rounded-full bg-gradient-to-r from-[#ea9804] to-[#fbb125] px-5 py-2 text-black"
          >
            Call {contactFirstName}
          </a>
        </div>
      </article>
    );
  }

  if (marker.kind === "driver") {
    const driverFirstName = firstName(marker.name);
    return (
      <article className="w-[320px] rounded-[18px] border border-white/10 bg-[#252525]/95 p-4 text-white shadow-[0_20px_36px_-20px_rgba(0,0,0,0.85)] backdrop-blur-sm">
        <div className="flex items-start justify-between gap-2">
          <p className="text-[34px] font-semibold italic leading-none">
            {marker.name} - {marker.role}
          </p>
          <span className="inline-flex h-6 w-6 items-center justify-center rounded-full bg-[#f4a20f] text-[10px] font-bold text-black">
            !
          </span>
        </div>
        <p className="mt-2 text-[42px] font-semibold leading-none">Driver Rating:</p>
        <div className="mt-1 flex items-center gap-1">{ratingStars(marker.rating ?? 4)}</div>
        <div className="mt-2 space-y-1 text-[14px] font-semibold italic">
          <p className="rounded-full border border-white/10 bg-[#1b1b1b] px-3 py-1 text-[#d2d2d2]">
            Car Driving: {marker.vehicle ?? "Not informed"}
          </p>
          <p className="rounded-full border border-white/10 bg-[#1b1b1b] px-3 py-1 text-[#d2d2d2]">
            Rides this month: {marker.ridesMonth ?? "-"} Total: {marker.ridesTotal ?? "-"}
          </p>
        </div>
        <p className="mt-2 text-center text-[42px] font-semibold italic leading-none text-[#1c7f36]">
          Status: {marker.status ?? "Available"}
        </p>
        <div className="mt-3 flex items-center justify-center gap-2 text-[36px] font-semibold italic leading-none">
          <Link
            href={buildChatRoute(marker.name, marker.role)}
            onClick={() =>
              onAction(marker, "text_driver", {
                driverName: marker.name,
                driverRole: marker.role,
                driverPhone: marker.phone ?? null,
              })
            }
            className="rounded-full bg-[#1b1b1b] px-5 py-2 text-white transition hover:bg-[#2a2a2a]"
          >
            Text {driverFirstName}
          </Link>
          <a
            href={marker.phone ? `tel:${marker.phone}` : "#"}
            onClick={() =>
              onAction(marker, "call_driver", {
                driverName: marker.name,
                driverRole: marker.role,
                driverPhone: marker.phone ?? null,
              })
            }
            className="rounded-full bg-gradient-to-r from-[#ea9804] to-[#fbb125] px-5 py-2 text-black"
          >
            Call {driverFirstName}
          </a>
        </div>
      </article>
    );
  }

  if (marker.kind === "sos_passenger") {
    const userLocationHref = `https://www.google.com/maps?q=${marker.lat},${marker.lng}`;
    return (
      <article className="w-[338px] rounded-[18px] border border-[#9f2f2f] bg-[#3d1414]/95 p-4 text-white shadow-[0_18px_34px_-20px_rgba(0,0,0,0.9)] backdrop-blur-sm">
        <div className="flex items-start justify-between">
          <p className="text-[35px] font-semibold italic leading-none">
            {marker.name} - {marker.role}
          </p>
          <span className="rounded-full bg-white/20 px-2 py-1 text-[11px] font-bold">SOS</span>
        </div>
        <div className="mt-2 space-y-1 text-[12px] text-[#f4dada]">
          <p className="rounded-md border border-white/15 bg-[#511b1b] px-2 py-0.5">
            Gender: {marker.gender ?? "-"}
          </p>
          <p className="rounded-md border border-white/15 bg-[#511b1b] px-2 py-0.5">
            Front: {marker.location ?? "-"}
          </p>
          <p className="rounded-md border border-white/15 bg-[#511b1b] px-2 py-0.5">
            Ethnicity: {marker.ethnicity ?? "-"}
          </p>
          <p className="rounded-md border border-white/15 bg-[#511b1b] px-2 py-0.5">
            Emergency contact: {marker.emergencyContact ?? "-"}
          </p>
        </div>
        <div className="mt-2 flex flex-wrap items-center gap-2 text-[11px] font-semibold">
          <button
            type="button"
            onClick={() => onAction(marker, "sos_call_emergency")}
            className="rounded-full bg-gradient-to-r from-[#ea9804] to-[#fbb125] px-3 py-1 text-[#101010]"
          >
            CALL 911 or 919
          </button>
          <button
            type="button"
            onClick={() =>
              onAction(marker, "view_passport", { passport: marker.passport ?? null })
            }
            className="rounded-full border border-white/15 bg-[#551f1f] px-3 py-1 text-white"
          >
            Passport #: {marker.passport ?? "-"}
          </button>
        </div>
        <div className="mt-2 flex flex-wrap gap-2 text-[10px] font-semibold">
          <button
            type="button"
            onClick={() => onAction(marker, "sos_call_driver")}
            className="rounded-full border border-white/10 bg-[#1b1b1b] px-3 py-1"
          >
            Call Driver
          </button>
          <button
            type="button"
            onClick={() => onAction(marker, "sos_ask_free_drivers_for_help")}
            className="rounded-full border border-white/10 bg-[#1b1b1b] px-3 py-1"
          >
            Ask free drivers for help
          </button>
          <a
            href={userLocationHref}
            target="_blank"
            rel="noreferrer"
            onClick={() => onAction(marker, "sos_open_user_location", { userLocationHref })}
            className="rounded-full border border-white/10 bg-[#1b1b1b] px-3 py-1"
          >
            User Location
          </a>
        </div>
      </article>
    );
  }

  return (
    <article className="w-[302px] rounded-[18px] border border-[#9f2f2f] bg-[#3d1414]/95 p-4 text-white shadow-[0_18px_34px_-20px_rgba(0,0,0,0.9)] backdrop-blur-sm">
      <div className="flex items-start justify-between gap-2">
        <p className="text-[35px] font-semibold italic leading-none">
          {marker.name} - {marker.role}
        </p>
        <span className="rounded-full bg-white/20 px-2 py-1 text-[11px] font-bold">SOS</span>
      </div>
      <p className="mt-2 text-[11px] font-semibold italic leading-tight">Going to Bahamar</p>
      <p className="mt-2 text-[9px] leading-tight text-white/95">
        {marker.message ??
          "Rider Requested Help! Please he has a gun! And we are not going in the direction of the maps... cannot talk."}
      </p>
      <div className="mt-2 flex items-center gap-2 text-[11px] font-semibold">
        <button
          type="button"
          onClick={() => onAction(marker, "threat_call_emergency")}
          className="rounded-full bg-gradient-to-r from-[#ea9804] to-[#fbb125] px-3 py-1 text-[#101010]"
        >
          CALL 911 or 919
        </button>
        <button
          type="button"
          onClick={() => onAction(marker, "threat_view_plate", { plate: marker.plate ?? null })}
          className="rounded-full border border-white/15 bg-[#551f1f] px-3 py-1 text-white"
        >
          Car Plate {marker.plate ?? "-"}
        </button>
      </div>
      <div className="mt-2 flex flex-wrap gap-2 text-[10px] font-semibold">
        <button
          type="button"
          onClick={() => onAction(marker, "threat_call_driver")}
          className="rounded-full border border-white/10 bg-[#1b1b1b] px-3 py-1"
        >
          Call Driver
        </button>
        <button
          type="button"
          onClick={() => onAction(marker, "threat_ask_free_drivers_for_help")}
          className="rounded-full border border-white/10 bg-[#1b1b1b] px-3 py-1"
        >
          Ask free drivers for help
        </button>
        <a
          href={userLocationHref}
          target="_blank"
          rel="noreferrer"
          onClick={() => onAction(marker, "threat_open_user_location", { userLocationHref })}
          className="rounded-full border border-white/10 bg-[#1b1b1b] px-3 py-1"
        >
          User Location
        </a>
      </div>
    </article>
  );
};

export default function FullScreenWorldMap() {
  const [activeMarkerId, setActiveMarkerId] = useState<string | null>(null);
  const [firebaseActionStatus, setFirebaseActionStatus] = useState<
    "idle" | "saving" | "error"
  >("idle");
  const icons = useMemo(
    () => ({
      passenger: createDivIcon(personSvg("#f3f3f3", "#2a2a2a"), 34, 40),
      driver: createDivIcon(carSvg("#f4a20f"), 40, 22),
      sos_passenger: createDivIcon(personSvg("#ea3d33", "#5b1a14"), 34, 40),
      threat_driver: createDivIcon(carSvg("#ef3c36"), 40, 22),
    }),
    []
  );

  const trackButtonAction: MapActionCallback = (marker, action, metadata = {}) => {
    setFirebaseActionStatus("saving");
    void (async () => {
      try {
        const hasAuth = await ensureFirebaseAuthSession();
        if (!hasAuth) {
          setFirebaseActionStatus("error");
          return;
        }

        const db = getFirebaseDb();
        await addDoc(collection(db, "mapButtonActions"), {
          markerId: marker.id,
          markerKind: marker.kind,
          markerName: marker.name,
          markerRole: marker.role,
          markerLat: marker.lat,
          markerLng: marker.lng,
          action,
          metadata,
          createdAt: serverTimestamp(),
        });
        setFirebaseActionStatus("idle");
      } catch {
        setFirebaseActionStatus("error");
      }
    })();
  };

  const trackUiAction = (action: string, metadata: Record<string, unknown> = {}) => {
    setFirebaseActionStatus("saving");
    void (async () => {
      try {
        const hasAuth = await ensureFirebaseAuthSession();
        if (!hasAuth) {
          setFirebaseActionStatus("error");
          return;
        }

        const db = getFirebaseDb();
        await addDoc(collection(db, "mapButtonActions"), {
          markerId: null,
          markerKind: "ui",
          markerName: null,
          markerRole: null,
          markerLat: null,
          markerLng: null,
          action,
          metadata,
          createdAt: serverTimestamp(),
        });
        setFirebaseActionStatus("idle");
      } catch {
        setFirebaseActionStatus("error");
      }
    })();
  };

  return (
    <div className="relative min-h-screen w-full overflow-hidden bg-[radial-gradient(circle_at_top,_rgba(240,140,0,0.18),_transparent_48%),linear-gradient(180deg,_#171717_0%,_#0f0f0f_65%,_#090909_100%)]">
      <MapContainer
        className="world-map h-screen w-full"
        center={[22, 0]}
        zoom={2}
        minZoom={2}
        maxZoom={19}
        worldCopyJump
        scrollWheelZoom
        zoomControl={false}
        maxBounds={[
          [-85, -180],
          [85, 180],
        ]}
        maxBoundsViscosity={0.5}
      >
        <TileLayer
          url="https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
          subdomains={["a", "b", "c", "d"]}
          errorTileUrl="data:image/gif;base64,R0lGODlhAQABAPAAAI2hoAAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw=="
          attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
        />
        <PopupReset onReset={() => setActiveMarkerId(null)} />
        <ZoomControl position="bottomright" />

        {MAP_MARKERS.map((marker) => (
          <Marker
            key={marker.id}
            position={[marker.lat, marker.lng]}
            icon={icons[marker.kind]}
            eventHandlers={{
              click: () => setActiveMarkerId(marker.id),
            }}
          >
            {activeMarkerId === marker.id ? (
              <Popup
                closeButton={false}
                autoPan
                autoPanPadding={[70, 120]}
                className={
                  marker.kind === "sos_passenger" || marker.kind === "threat_driver"
                    ? "world-map-popup world-map-popup-danger"
                    : "world-map-popup"
                }
              >
                {renderPopupContent(marker, trackButtonAction)}
              </Popup>
            ) : null}
          </Marker>
        ))}
      </MapContainer>

      <div className="pointer-events-none absolute inset-x-0 top-0 z-[900] px-3 pt-2 lg:px-4">
        <header className="pointer-events-auto mx-auto flex w-full max-w-[1880px] flex-wrap items-center gap-3 rounded-2xl border border-white/10 bg-[#2b2b2b]/92 px-4 py-3 shadow-[0_16px_40px_-26px_rgba(0,0,0,0.92)] backdrop-blur-sm">
          <div className="flex items-center gap-3">
            <img
              src="/flutter_assets/images/ride_gradient_190_fb9000_fbb125.png"
              alt="Ride logo"
              className="h-11 w-auto rounded-lg"
            />
            <div className="hidden items-center gap-2 rounded-full bg-[#1f1f1f] px-3 py-2 text-xs text-[var(--text-muted)] md:flex">
              <span className="rounded-full bg-[#2e2e2e] px-3 py-1 text-[10px] uppercase tracking-[0.2em]">
                Lifetime
              </span>
              <span>Dashboard Snapshot</span>
            </div>
          </div>

          <div className="flex min-w-[240px] flex-1 items-center gap-2">
            <div className="hidden min-w-[240px] flex-1 items-center gap-2 rounded-full bg-[#1f1f1f] px-4 py-2 text-sm text-[var(--text-soft)] xl:flex">
              <span className="text-xs uppercase tracking-[0.2em] text-[var(--text-muted)]">
                Search
              </span>
              <span className="truncate text-[10px] text-[var(--text-soft)]">
                Dashboard Snapshot
              </span>
            </div>
            <nav className="flex flex-wrap items-center gap-2">
              {topNavLinks.map((item) => {
                const active = item.href === "/map";
                return (
                  <Link
                    key={`map-nav-${item.label}`}
                    href={item.href}
                    onClick={() =>
                      trackUiAction("top_nav_click", { label: item.label, href: item.href })
                    }
                    className={[
                      "rounded-full px-3 py-2 text-xs transition",
                      active
                        ? "bg-[#f4a20f] text-black"
                        : "bg-[#1e1e1e] text-[var(--text-muted)] hover:bg-[#2b2b2b] hover:text-white",
                    ].join(" ")}
                  >
                    {item.label}
                  </Link>
                );
              })}
            </nav>
          </div>

          <div className="flex items-center gap-2">
            <button
              type="button"
              onClick={() => trackUiAction("dark_theme_toggle_click")}
              className="rounded-full bg-gradient-to-r from-[#c97200] to-[#fbb125] px-3 py-2 text-xs font-semibold text-black"
            >
              Dark
            </button>
            <button
              type="button"
              onClick={() => trackUiAction("user_chip_click")}
              className="rounded-full bg-[#1f1f1f] px-3 py-2 text-xs text-[var(--text-muted)]"
            >
              User
            </button>
            <button
              type="button"
              onClick={() => trackUiAction("profile_chip_click", { name: "Enzo Godoy" })}
              className="flex items-center gap-2 rounded-full bg-[#1f1f1f] px-3 py-2"
            >
              <img
                src="/flutter_assets/images/perfil_transparente_cortado.png"
                alt="Profile"
                className="h-8 w-8 rounded-full border border-white/10"
              />
              <span className="text-xs text-[var(--text-muted)]">Enzo Godoy</span>
            </button>
          </div>
        </header>
      </div>

      {firebaseActionStatus === "error" ? (
        <div className="pointer-events-none absolute bottom-4 left-1/2 z-[950] -translate-x-1/2 rounded-full bg-[#f03830] px-4 py-2 text-xs font-semibold text-white shadow-[0_10px_24px_-12px_rgba(0,0,0,0.9)]">
          Nao foi possivel salvar a acao no Firebase.
        </div>
      ) : null}
    </div>
  );
}
