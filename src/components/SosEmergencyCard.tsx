"use client";

import Link from "next/link";
import { useEffect, useMemo, useState } from "react";
import {
  collection,
  DocumentData,
  DocumentReference,
  GeoPoint,
  getDoc,
  getDocs,
  limit,
  onSnapshot,
  orderBy,
  query,
  QueryDocumentSnapshot,
  serverTimestamp,
  updateDoc,
  where,
} from "firebase/firestore";
import { httpsCallable } from "firebase/functions";

import { getFirebaseDb, getFirebaseFunctions } from "@/lib/firebase/client";

type SosEmergencyCardProps = {
  askDriversHref: string;
  fallbackUserLocationHref: string;
};

type IncidentData = {
  message: string;
  destination: string;
  plate: string;
  riderName: string;
  riderStatus: string;
  gender: string;
  from: string;
  passport: string;
  riderPhone?: string;
  driverName: string;
  driverPhone?: string;
  userLocationHref?: string;
  riderRef?: DocumentReference<DocumentData>;
  driverRef?: DocumentReference<DocumentData>;
};

type UpsertEmergencyPhonesPayload = {
  driverUserPath?: string;
  driverPhoneNumber?: string;
  riderUserPath?: string;
  riderPhoneNumber?: string;
};

const DEFAULT_INCIDENT: IncidentData = {
  message: "Please he has a gun!! And we are not going the direction of the maps....cannot talk.",
  destination: "Going to Bahamar",
  plate: "EAD199",
  riderName: "Giulia Baeder",
  riderStatus: "Not in a Ride",
  gender: "Female",
  from: "United states, Florida",
  passport: "GB882306",
  driverName: "Sam Miller",
};

const cleanText = (value: unknown): string | undefined => {
  if (typeof value === "string") {
    const text = value.trim();
    return text ? text : undefined;
  }
  if (typeof value === "number") {
    return String(value);
  }
  return undefined;
};

const pickText = (
  data: Record<string, unknown> | undefined,
  keys: string[]
): string | undefined => {
  if (!data) return undefined;
  for (const key of keys) {
    const text = cleanText(data[key]);
    if (text) return text;
  }
  return undefined;
};

const pickDocRef = (
  data: Record<string, unknown> | undefined,
  keys: string[]
): DocumentReference<DocumentData> | undefined => {
  if (!data) return undefined;
  for (const key of keys) {
    const value = data[key];
    if (value instanceof DocumentReference) {
      return value as DocumentReference<DocumentData>;
    }
  }
  return undefined;
};

const parseGeoPoint = (
  value: unknown
): { latitude: number; longitude: number } | undefined => {
  if (value instanceof GeoPoint) {
    return { latitude: value.latitude, longitude: value.longitude };
  }
  if (typeof value !== "object" || value === null) return undefined;

  const maybeGeo = value as { latitude?: unknown; longitude?: unknown };
  if (
    typeof maybeGeo.latitude === "number" &&
    typeof maybeGeo.longitude === "number"
  ) {
    return { latitude: maybeGeo.latitude, longitude: maybeGeo.longitude };
  }

  return undefined;
};

const formatLocation = (riderData: Record<string, unknown> | undefined) => {
  const explicit = pickText(riderData, [
    "from",
    "fromLocation",
    "whereFrom",
    "address",
    "cityState",
  ]);
  if (explicit) return explicit;

  const city = pickText(riderData, ["city", "cidade"]);
  const state = pickText(riderData, ["state", "estado"]);
  const country = pickText(riderData, ["country", "pais", "país"]);

  const joined = [city, state, country].filter(Boolean).join(", ");
  if (joined) return joined;

  const geo = parseGeoPoint(riderData?.location);
  if (geo) {
    return `${geo.latitude.toFixed(5)}, ${geo.longitude.toFixed(5)}`;
  }

  return "Not informed";
};

const normalizePhone = (value?: string) => value?.replace(/[^\d+]/g, "");

const isSosMessage = (text?: string, rideSOS?: unknown) => {
  if (Boolean(rideSOS)) return true;
  if (!text) return false;
  return /\b(sos|help|socorro|danger|emergency|crime|gun|arma|911|919)\b/i.test(
    text
  );
};

const pickPhoneFromEmergencyContacts = (
  data: Record<string, unknown> | undefined
): string | undefined => {
  const contacts = data?.emergencyContacts;
  if (!Array.isArray(contacts)) return undefined;

  for (const entry of contacts) {
    if (typeof entry !== "object" || entry === null) continue;
    const number = cleanText((entry as Record<string, unknown>).number);
    if (number) return number;
  }

  return undefined;
};

const pickUserPhone = (data: Record<string, unknown> | undefined) => {
  return (
    pickText(data, [
      "phone_number",
      "phoneNumber",
      "phone",
      "mobile",
      "cellphone",
      "telephone",
      "telefone",
    ]) ?? pickPhoneFromEmergencyContacts(data)
  );
};

const resolveRideOrderRef = async (
  chatData: Record<string, unknown>,
  riderData: Record<string, unknown> | undefined,
  riderRef?: DocumentReference<DocumentData>
): Promise<DocumentReference<DocumentData> | undefined> => {
  const fromChat = pickDocRef(chatData, ["rideOrderReference", "referenceTask"]);
  if (fromChat) return fromChat;

  const fromRiderDoc = pickDocRef(riderData, ["rideOn"]);
  if (fromRiderDoc) return fromRiderDoc;

  if (!riderRef) return undefined;

  const db = getFirebaseDb();

  const byUser = await getDocs(
    query(collection(db, "rideOrders"), where("user", "==", riderRef), limit(1))
  );
  if (!byUser.empty) {
    return byUser.docs[0].ref;
  }

  const byUsers = await getDocs(
    query(collection(db, "rideOrders"), where("users", "==", riderRef), limit(1))
  );
  if (!byUsers.empty) {
    return byUsers.docs[0].ref;
  }

  return undefined;
};

const loadIncidentFromChats = async (
  chatDocs: QueryDocumentSnapshot<DocumentData>[]
): Promise<IncidentData | null> => {
  for (const chatDoc of chatDocs) {
    const chatData = chatDoc.data() as Record<string, unknown>;
    const historySnap = await getDocs(
      query(collection(chatDoc.ref, "chatHistory"), orderBy("horario", "desc"), limit(5))
    );

    if (historySnap.empty) continue;

    const messageDoc =
      historySnap.docs.find((entry) => Boolean(entry.data().rideSOS)) ??
      historySnap.docs.find((entry) =>
        isSosMessage(cleanText(entry.data().msg), entry.data().rideSOS)
      ) ??
      historySnap.docs[0];

    const messageData = messageDoc.data() as Record<string, unknown>;
    const messageText = pickText(messageData, ["msg", "message", "mensagem"]);

    if (!isSosMessage(messageText, messageData.rideSOS)) continue;

    const messageUserRef = pickDocRef(messageData, ["documentUser"]);
    const riderRef = messageUserRef ?? pickDocRef(chatData, ["userDocument"]);

    const riderSnap = riderRef ? await getDoc(riderRef) : null;
    const riderData = riderSnap?.exists()
      ? (riderSnap.data() as Record<string, unknown>)
      : undefined;

    const rideOrderRef = await resolveRideOrderRef(chatData, riderData, riderRef);
    const rideOrderSnap = rideOrderRef ? await getDoc(rideOrderRef) : null;
    const rideOrderData = rideOrderSnap?.exists()
      ? (rideOrderSnap.data() as Record<string, unknown>)
      : undefined;

    const driverRef =
      pickDocRef(rideOrderData, ["driver"]) ??
      pickDocRef(chatData, ["user2Document"]);

    const driverSnap = driverRef ? await getDoc(driverRef) : null;
    const driverData = driverSnap?.exists()
      ? (driverSnap.data() as Record<string, unknown>)
      : undefined;

    const riderName =
      pickText(riderData, ["display_name", "displayName", "name"]) ??
      DEFAULT_INCIDENT.riderName;

    const driverName =
      pickText(driverData, ["display_name", "displayName", "name"]) ??
      DEFAULT_INCIDENT.driverName;

    const driverPhone = pickUserPhone(driverData);
    const riderPhone = pickUserPhone(riderData);

    const plate =
      pickText(driverData, [
        "vehiclePlate",
        "plate",
        "placa",
        "carPlate",
        "plateNumber",
      ]) ??
      pickText(rideOrderData, ["vehiclePlate", "plate", "placa", "carPlate"]) ??
      "Not informed";

    const destination =
      pickText(rideOrderData, [
        "nomeDestino",
        "destination",
        "to",
        "goingTo",
        "dropoff",
      ]) ?? DEFAULT_INCIDENT.destination;

    const gender =
      pickText(riderData, ["gender", "genero", "genre", "sex"]) ?? "Not informed";

    const passport =
      pickText(riderData, [
        "passport",
        "passportNumber",
        "passport_number",
        "passaporte",
      ]) ?? "Not informed";

    const from = formatLocation(riderData);

    const geo = parseGeoPoint(riderData?.location);
    const userLocationHref = geo
      ? `https://www.google.com/maps?q=${geo.latitude},${geo.longitude}`
      : undefined;

    return {
      message: messageText ?? DEFAULT_INCIDENT.message,
      destination,
      plate,
      riderName,
      riderStatus: pickText(riderData, ["status", "taskOrTaskee"]) ?? "In ride",
      gender,
      from,
      passport,
      riderPhone,
      driverName,
      driverPhone,
      userLocationHref,
      riderRef,
      driverRef,
    };
  }

  return null;
};

export default function SosEmergencyCard({
  askDriversHref,
  fallbackUserLocationHref,
}: SosEmergencyCardProps) {
  const [incident, setIncident] = useState<IncidentData>(DEFAULT_INCIDENT);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [saveStatus, setSaveStatus] = useState<string | null>(null);
  const [driverPhoneInput, setDriverPhoneInput] = useState("");
  const [riderPhoneInput, setRiderPhoneInput] = useState("");

  useEffect(() => {
    const db = getFirebaseDb();
    let active = true;
    let requestId = 0;

    const chatsQuery = query(
      collection(db, "chat"),
      orderBy("ultimaMsg", "desc"),
      limit(20)
    );

    const unsubscribe = onSnapshot(
      chatsQuery,
      (snapshot) => {
        requestId += 1;
        const currentRequest = requestId;

        void (async () => {
          try {
            const nextIncident = await loadIncidentFromChats(snapshot.docs);
            if (!active || currentRequest !== requestId) return;
            if (nextIncident) {
              setIncident(nextIncident);
            } else {
              setIncident(DEFAULT_INCIDENT);
            }
          } catch {
            if (!active || currentRequest !== requestId) return;
            setIncident(DEFAULT_INCIDENT);
          } finally {
            if (active && currentRequest === requestId) {
              setLoading(false);
            }
          }
        })();
      },
      () => {
        if (!active) return;
        setIncident(DEFAULT_INCIDENT);
        setLoading(false);
      }
    );

    return () => {
      active = false;
      unsubscribe();
    };
  }, []);

  useEffect(() => {
    setDriverPhoneInput(incident.driverPhone ?? "");
    setRiderPhoneInput(incident.riderPhone ?? "");
  }, [incident.driverPhone, incident.riderPhone]);

  const driverPhone = useMemo(() => normalizePhone(incident.driverPhone), [incident.driverPhone]);
  const riderPhone = useMemo(() => normalizePhone(incident.riderPhone), [incident.riderPhone]);

  const handleEmergencyCall = () => {
    if (typeof window === "undefined") return;
    const call911 = window.confirm(
      "Pressione OK para ligar para 911. Pressione Cancelar para ligar para 919."
    );
    window.location.href = call911 ? "tel:911" : "tel:919";
  };

  const savePhoneWithDirectUpdate = async (
    userRef: DocumentReference<DocumentData>,
    phone: string
  ) => {
    await updateDoc(userRef, {
      phone_number: phone,
      phoneNumber: phone,
      updatedAt: serverTimestamp(),
    });
  };

  const handleSavePhones = async () => {
    const driverPhoneNumber = normalizePhone(driverPhoneInput);
    const riderPhoneNumber = normalizePhone(riderPhoneInput);

    if (!incident.driverRef && !incident.riderRef) {
      setSaveStatus("No SOS users found to update in Firebase.");
      return;
    }

    if (!driverPhoneNumber && !riderPhoneNumber) {
      setSaveStatus("Enter at least one phone number.");
      return;
    }

    setSaving(true);
    setSaveStatus("Saving phone numbers in Firebase...");

    try {
      const callable = httpsCallable<
        UpsertEmergencyPhonesPayload,
        { updated: string[] }
      >(getFirebaseFunctions(), "upsertEmergencyPhones");

      await callable({
        driverUserPath: incident.driverRef?.path,
        driverPhoneNumber,
        riderUserPath: incident.riderRef?.path,
        riderPhoneNumber,
      });

      setIncident((prev) => ({
        ...prev,
        driverPhone: driverPhoneNumber ?? prev.driverPhone,
        riderPhone: riderPhoneNumber ?? prev.riderPhone,
      }));

      setSaveStatus("Phone numbers saved in Firebase.");
    } catch {
      try {
        const updates: Promise<void>[] = [];
        if (incident.driverRef && driverPhoneNumber) {
          updates.push(savePhoneWithDirectUpdate(incident.driverRef, driverPhoneNumber));
        }
        if (incident.riderRef && riderPhoneNumber) {
          updates.push(savePhoneWithDirectUpdate(incident.riderRef, riderPhoneNumber));
        }

        if (!updates.length) {
          throw new Error("No documents to update.");
        }

        await Promise.all(updates);

        setIncident((prev) => ({
          ...prev,
          driverPhone: driverPhoneNumber ?? prev.driverPhone,
          riderPhone: riderPhoneNumber ?? prev.riderPhone,
        }));

        setSaveStatus("Phone numbers saved in Firebase.");
      } catch {
        setSaveStatus(
          "Could not save phones now. Deploy function upsertEmergencyPhones or check Firestore write permissions."
        );
      }
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4 md:col-span-2">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <p className="text-sm font-semibold text-white">Rider Requested Help</p>
          <p className="text-xs text-[var(--text-muted)]">{incident.message}</p>
        </div>
        <button
          type="button"
          onClick={handleEmergencyCall}
          className="rounded-xl bg-[#5a1a1a] px-4 py-2 text-xs font-semibold text-[#ffb3b3] transition hover:brightness-110"
        >
          CALL 911 or 919
        </button>
      </div>

      <div className="mt-4 grid gap-3 md:grid-cols-3">
        <div className="rounded-xl bg-[#1f1f1f] p-3 text-xs text-[var(--text-muted)]">
          {incident.destination}
          <div className="mt-2 text-sm text-white">Car Plate #{incident.plate}</div>
          <div className="mt-1 text-[11px] text-[var(--text-soft)]">
            Driver Phone: {driverPhone ?? "Not informed"}
          </div>
        </div>
        <div className="rounded-xl bg-[#1f1f1f] p-3 text-xs text-[var(--text-muted)]">
          {incident.riderName} - {incident.riderStatus}
          <div className="mt-2 text-sm text-white">Gender: {incident.gender}</div>
          <div className="mt-1 text-[11px] text-[var(--text-soft)]">
            Rider Phone: {riderPhone ?? "Not informed"}
          </div>
        </div>
        <div className="rounded-xl bg-[#1f1f1f] p-3 text-xs text-[var(--text-muted)]">
          From: {incident.from}
          <div className="mt-2 text-sm text-white">Passport #: {incident.passport}</div>
        </div>
      </div>

      <div className="mt-3 grid gap-2 md:grid-cols-[1fr_1fr_auto]">
        <input
          value={driverPhoneInput}
          onChange={(event) => setDriverPhoneInput(event.target.value)}
          placeholder="Driver phone"
          className="rounded-full border border-white/10 bg-[#1f1f1f] px-3 py-2 text-xs text-white outline-none placeholder:text-[var(--text-muted)]"
        />
        <input
          value={riderPhoneInput}
          onChange={(event) => setRiderPhoneInput(event.target.value)}
          placeholder="Rider phone"
          className="rounded-full border border-white/10 bg-[#1f1f1f] px-3 py-2 text-xs text-white outline-none placeholder:text-[var(--text-muted)]"
        />
        <button
          type="button"
          onClick={handleSavePhones}
          disabled={saving}
          className="rounded-full bg-[#1f1f1f] px-4 py-2 text-xs text-[var(--text-soft)] transition hover:bg-[#2b2b2b] disabled:opacity-60"
        >
          {saving ? "Saving..." : "Save Phones"}
        </button>
      </div>

      {saveStatus ? (
        <p className="mt-2 text-[10px] text-[var(--text-muted)]">{saveStatus}</p>
      ) : null}

      <div className="mt-4 flex flex-wrap gap-2 text-[10px] text-[var(--text-soft)]">
        {driverPhone ? (
          <a
            href={`tel:${driverPhone}`}
            className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
          >
            Call Driver
          </a>
        ) : (
          <span className="rounded-full bg-[#1f1f1f] px-3 py-1 text-[var(--text-muted)]">
            Driver phone unavailable
          </span>
        )}

        {riderPhone ? (
          <a
            href={`tel:${riderPhone}`}
            className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
          >
            Call Rider
          </a>
        ) : null}

        <Link
          href={askDriversHref}
          className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
        >
          Ask free Drivers for help
        </Link>

        {incident.userLocationHref ? (
          <a
            href={incident.userLocationHref}
            target="_blank"
            rel="noreferrer"
            className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
          >
            User Location
          </a>
        ) : (
          <Link
            href={fallbackUserLocationHref}
            className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
          >
            User Location
          </Link>
        )}

        {loading ? <span className="rounded-full bg-[#1f1f1f] px-3 py-1">Syncing SOS...</span> : null}
      </div>
    </div>
  );
}
