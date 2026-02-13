"use client";

import Link from "next/link";
import { FirebaseError } from "firebase/app";
import { collection, onSnapshot } from "firebase/firestore";
import { useEffect, useMemo, useState, type ReactNode } from "react";

import { ensureFirebaseAuthSession, getFirebaseDb } from "@/lib/firebase/client";

type Lane = "riders" | "local" | "taxi";

type DashboardUser = {
  id: string;
  displayName: string;
  photoUrl?: string;
  email?: string;
  phone?: string;
  rides: number;
  location: string;
  platforms: string[];
};

type LaneStyle = {
  cardBackground: string;
  leftBackground: string;
  wedgeColor: string;
  nameClassName: string;
  textClassName: string;
  metaClassName: string;
  squareMode: "light" | "dark";
};

const TOP_NAV_LINKS = [
  { label: "Dashboard", href: "/quickysolutionsllcdashboard" },
  { label: "Disputes & Expense", href: "/disputes-expense" },
  { label: "Dispute Resolution", href: "/edittask" },
  {
    label: "Flow Builder, Campaigns & Rewards",
    href: "/flow-builder-campaigns-rewards",
  },
  { label: "Users", href: "/users" },
  { label: "map", href: "/map" },
];

const LANE_META: Record<Lane, { title: string; roleLabel: string }> = {
  riders: { title: "Riders", roleLabel: "Rider" },
  local: { title: "Local Driver", roleLabel: "Local Driver" },
  taxi: { title: "Taxi Driver", roleLabel: "Taxi Driver" },
};

const LANE_STYLES: Record<Lane, LaneStyle> = {
  riders: {
    cardBackground: "linear-gradient(135deg, #3b3b3b 0%, #484848 100%)",
    leftBackground: "linear-gradient(180deg, #2f2f2f 0%, #1d1d1d 100%)",
    wedgeColor: "#484848",
    nameClassName: "text-white",
    textClassName: "text-white/90",
    metaClassName: "text-white/90",
    squareMode: "light",
  },
  local: {
    cardBackground: "linear-gradient(135deg, #f4f4f4 0%, #ffffff 100%)",
    leftBackground: "linear-gradient(180deg, #2f2f2f 0%, #1d1d1d 100%)",
    wedgeColor: "#f3f3f3",
    nameClassName: "text-[#202020]",
    textClassName: "text-[#2a2a2a]",
    metaClassName: "text-[#2f2f2f]",
    squareMode: "dark",
  },
  taxi: {
    cardBackground: "linear-gradient(135deg, #f39b1d 0%, #fbb125 100%)",
    leftBackground: "linear-gradient(180deg, #2f2f2f 0%, #1d1d1d 100%)",
    wedgeColor: "#f5a61c",
    nameClassName: "text-white",
    textClassName: "text-white",
    metaClassName: "text-white",
    squareMode: "light",
  },
};

const RIDER_PLATFORMS = new Set(["ride bahamas", "ride visitor"]);
const LOCAL_DRIVER_PLATFORMS = new Set(["ride driver"]);
const TAXI_PLATFORMS = new Set(["ride taxi"]);

const cleanText = (value: unknown): string | undefined => {
  if (typeof value !== "string") return undefined;
  const text = value.trim();
  return text.length > 0 ? text : undefined;
};

const readInteger = (value: unknown): number => {
  if (typeof value === "number" && Number.isFinite(value)) {
    return Math.max(0, Math.floor(value));
  }
  if (typeof value === "string") {
    const parsed = Number.parseInt(value, 10);
    if (Number.isFinite(parsed)) {
      return Math.max(0, parsed);
    }
  }
  return 0;
};

const normalizePlatform = (value: string): string =>
  value
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/\s+/g, " ")
    .trim()
    .toLowerCase();

const readPlatforms = (data: Record<string, unknown>): string[] => {
  const rawPlatform = data.plaform ?? data.plataform ?? data.platform;
  if (Array.isArray(rawPlatform)) {
    return rawPlatform
      .map((entry) => cleanText(entry))
      .filter((entry): entry is string => Boolean(entry));
  }

  const singlePlatform = cleanText(rawPlatform);
  if (!singlePlatform) return [];

  return singlePlatform
    .split(",")
    .map((entry) => entry.trim())
    .filter((entry) => entry.length > 0);
};

const readLocation = (data: Record<string, unknown>): string => {
  const fromField = cleanText(data.stateEtinia) ?? cleanText(data.location);
  if (fromField) {
    return fromField.toLowerCase().startsWith("from ")
      ? fromField
      : `From ${fromField}`;
  }

  const country = cleanText(data.country) ?? cleanText(data.country_name);
  const state = cleanText(data.state) ?? cleanText(data.region);

  if (country && state) return `From ${country}, ${state}`;
  if (country) return `From ${country}`;
  return "From US, Florida";
};

const sanitizePhone = (value?: string): string | undefined => {
  if (!value) return undefined;
  const phone = value.replace(/[^\d+]/g, "");
  return phone.length > 0 ? phone : undefined;
};

const toDashboardUser = (
  id: string,
  data: Record<string, unknown>
): DashboardUser => ({
  id,
  displayName:
    cleanText(data.display_name) ??
    cleanText(data.displayName) ??
    cleanText(data.name) ??
    "User",
  photoUrl:
    cleanText(data.photo_url) ??
    cleanText(data.photoUrl) ??
    cleanText(data.avatar),
  email: cleanText(data.email),
  phone:
    cleanText(data.phone_number) ??
    cleanText(data.phoneNumber) ??
    cleanText(data.phone),
  rides: readInteger(data.requestEmNumber ?? data.rides ?? data.totalRides),
  location: readLocation(data),
  platforms: readPlatforms(data),
});

const classifyUser = (user: DashboardUser): Lane[] => {
  const normalizedPlatforms = user.platforms.map(normalizePlatform);
  const lanes: Lane[] = [];

  if (normalizedPlatforms.some((entry) => RIDER_PLATFORMS.has(entry))) {
    lanes.push("riders");
  }

  if (normalizedPlatforms.some((entry) => LOCAL_DRIVER_PLATFORMS.has(entry))) {
    lanes.push("local");
  }

  if (normalizedPlatforms.some((entry) => TAXI_PLATFORMS.has(entry))) {
    lanes.push("taxi");
  }

  return lanes;
};

const firebaseErrorMessage = (error: unknown, fallback: string): string => {
  if (error instanceof FirebaseError) {
    return `${fallback} (${error.code})`;
  }
  return fallback;
};

function ChatIcon() {
  return (
    <svg viewBox="0 0 24 24" className="h-4 w-4 fill-current" aria-hidden="true">
      <path d="M4.5 4.5h15a1 1 0 0 1 1 1v9a1 1 0 0 1-1 1H9.41l-4.22 3.16A.75.75 0 0 1 4 18.06V15.5h-.5a1 1 0 0 1-1-1v-9a1 1 0 0 1 1-1Zm1.5 2v7h.5a1.5 1.5 0 0 1 1.5 1.5v.06l1.68-1.26a1.5 1.5 0 0 1 .9-.3H18v-7H6Z" />
    </svg>
  );
}

function PhoneIcon() {
  return (
    <svg viewBox="0 0 24 24" className="h-4 w-4 fill-current" aria-hidden="true">
      <path d="M8.25 2.5h7.5c1.24 0 2.25 1 2.25 2.25v14.5c0 1.24-1 2.25-2.25 2.25h-7.5A2.25 2.25 0 0 1 6 19.25V4.75c0-1.24 1-2.25 2.25-2.25Zm0 2A.25.25 0 0 0 8 4.75v14.5c0 .14.11.25.25.25h7.5a.25.25 0 0 0 .25-.25V4.75a.25.25 0 0 0-.25-.25h-7.5ZM12 17.5a1.25 1.25 0 1 1 0 2.5 1.25 1.25 0 0 1 0-2.5Z" />
    </svg>
  );
}

function MailIcon() {
  return (
    <svg viewBox="0 0 24 24" className="h-4 w-4 fill-current" aria-hidden="true">
      <path d="M4 5.5h16A1.5 1.5 0 0 1 21.5 7v10A1.5 1.5 0 0 1 20 18.5H4A1.5 1.5 0 0 1 2.5 17V7A1.5 1.5 0 0 1 4 5.5Zm0 2v.24l8 4.8 8-4.8V7.5H4Zm16 9v-6.43l-7.61 4.57a1 1 0 0 1-1.03 0L4 10.07v6.43h16Z" />
    </svg>
  );
}

function UserGlyph() {
  return (
    <svg viewBox="0 0 24 24" className="h-5 w-5 fill-current" aria-hidden="true">
      <path d="M12 12.5a4.5 4.5 0 1 0 0-9 4.5 4.5 0 0 0 0 9Zm0 2c-4.28 0-7.75 2.57-7.75 5.75 0 .69.56 1.25 1.25 1.25h13a1.25 1.25 0 0 0 1.25-1.25c0-3.18-3.47-5.75-7.75-5.75Z" />
    </svg>
  );
}

function TwinSquares({ mode }: { mode: "light" | "dark" }) {
  const squareClassName =
    mode === "dark"
      ? "border-[#d4a94c] bg-[#1f1f1f]"
      : "border-[#2f2f2f] bg-white";

  return (
    <div className="relative h-6 w-8" aria-hidden="true">
      <span
        className={`absolute right-0 top-0 h-4 w-4 rounded-[4px] border ${squareClassName}`}
      />
      <span
        className={`absolute bottom-0 left-0 h-4 w-4 rounded-[4px] border ${squareClassName}`}
      />
    </div>
  );
}

function AvatarImage({
  src,
  alt,
  className,
}: {
  src?: string;
  alt: string;
  className: string;
}) {
  const [hasError, setHasError] = useState(false);
  const showPhoto = Boolean(src) && !hasError;

  if (showPhoto) {
    return (
      <img
        src={src}
        alt={alt}
        className={className}
        onError={() => setHasError(true)}
      />
    );
  }

  return (
    <div
      aria-label={alt}
      className={`${className} bg-[conic-gradient(from_45deg,_#d9d9d9_0_25%,_#8f8f8f_25%_50%,_#d9d9d9_50%_75%,_#8f8f8f_75%_100%)]`}
    />
  );
}

function ActionCircle({
  href,
  label,
  children,
}: {
  href?: string;
  label: string;
  children: ReactNode;
}) {
  const className =
    "grid h-8 w-8 place-items-center rounded-full border border-black/20 bg-[linear-gradient(135deg,#eef3f8,#bec8d3)] text-[#1f1f1f] shadow-[0_4px_10px_-6px_rgba(0,0,0,0.9)] transition hover:brightness-105";

  if (!href) {
    return (
      <span
        className={`${className} cursor-not-allowed opacity-40`}
        aria-label={`${label} indisponivel`}
      >
        {children}
      </span>
    );
  }

  if (href.startsWith("tel:") || href.startsWith("mailto:")) {
    return (
      <a href={href} className={className} aria-label={label}>
        {children}
      </a>
    );
  }

  return (
    <Link href={href} className={className} aria-label={label}>
      {children}
    </Link>
  );
}

function UserCard({ lane, user }: { lane: Lane; user: DashboardUser }) {
  const style = LANE_STYLES[lane];
  const laneRole = LANE_META[lane].roleLabel;
  const chatHref = `/profile-chat?name=${encodeURIComponent(
    user.displayName
  )}&role=${encodeURIComponent(laneRole)}&userId=${encodeURIComponent(user.id)}`;
  const callHref = sanitizePhone(user.phone)
    ? `tel:${sanitizePhone(user.phone)}`
    : undefined;
  const emailHref = user.email ? `mailto:${user.email}` : undefined;

  return (
    <article
      className="overflow-hidden rounded-2xl border border-black/35 shadow-[0_16px_28px_-20px_rgba(0,0,0,0.95)]"
      style={{ background: style.cardBackground }}
    >
      <div className="grid min-h-[126px] grid-cols-[96px_1fr]">
        <div className="relative flex items-center justify-center" style={{ background: style.leftBackground }}>
          <div
            className="absolute inset-y-0 right-0 w-8"
            style={{
              backgroundColor: style.wedgeColor,
              clipPath: "polygon(0 0, 100% 0, 70% 100%, 0 100%)",
            }}
          />
          <AvatarImage
            src={user.photoUrl}
            alt={user.displayName}
            className="relative z-[1] h-14 w-14 rounded-full object-cover ring-1 ring-black/25"
          />
        </div>

        <div className="flex min-w-0 flex-col justify-between px-4 py-3">
          <div className="flex items-start justify-between gap-3">
            <h3
              className={`min-w-0 truncate text-[34px] font-bold italic leading-none ${style.nameClassName}`}
            >
              {user.displayName}
            </h3>
            <TwinSquares mode={style.squareMode} />
          </div>

          <div className="flex items-end justify-between gap-3">
            <div className="flex items-center gap-2">
              <ActionCircle
                href={chatHref}
                label={`Abrir chat com ${user.displayName}`}
              >
                <ChatIcon />
              </ActionCircle>
              <ActionCircle href={callHref} label={`Ligar para ${user.displayName}`}>
                <PhoneIcon />
              </ActionCircle>
              <ActionCircle
                href={emailHref}
                label={`Enviar email para ${user.displayName}`}
              >
                <MailIcon />
              </ActionCircle>
            </div>

            <div className={`text-right text-xs leading-tight ${style.metaClassName}`}>
              <p className="font-semibold">{user.rides} Rides</p>
              <p className={style.textClassName}>{user.location}</p>
            </div>
          </div>
        </div>
      </div>
    </article>
  );
}

function UserLane({
  lane,
  users,
  loading,
}: {
  lane: Lane;
  users: DashboardUser[];
  loading: boolean;
}) {
  const title = LANE_META[lane].title;

  return (
    <section className="space-y-4">
      <div className="flex items-center justify-between gap-3">
        <h2 className="text-4xl font-semibold italic text-white">{title}</h2>
        {!loading ? (
          <span className="rounded-full bg-[#1c1c1c] px-3 py-1 text-xs text-[#c2c2c2]">
            {users.length}
          </span>
        ) : null}
      </div>

      <div className="space-y-5">
        {loading ? (
          <div className="rounded-2xl border border-white/10 bg-[#232323] px-4 py-10 text-center text-sm text-[#9f9f9f]">
            Carregando usuarios...
          </div>
        ) : null}

        {!loading && users.length === 0 ? (
          <div className="rounded-2xl border border-white/10 bg-[#232323] px-4 py-10 text-center text-sm text-[#9f9f9f]">
            Nenhum usuario encontrado para este grupo.
          </div>
        ) : null}

        {!loading
          ? users.map((user) => <UserCard key={`${lane}-${user.id}`} lane={lane} user={user} />)
          : null}
      </div>
    </section>
  );
}

export default function UsersPage() {
  const [users, setUsers] = useState<DashboardUser[]>([]);
  const [loading, setLoading] = useState(true);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [authWarning, setAuthWarning] = useState<string | null>(null);

  useEffect(() => {
    let active = true;
    let unsubscribe: (() => void) | null = null;

    void (async () => {
      const hasAuth = await ensureFirebaseAuthSession();
      if (!active) return;

      if (!hasAuth) {
        setAuthWarning(
          "Sessao anonima nao foi iniciada. Tentando carregar usuarios sem autenticacao."
        );
      }

      const db = getFirebaseDb();
      const usersRef = collection(db, "users");

      unsubscribe = onSnapshot(
        usersRef,
        (snapshot) => {
          if (!active) return;
          const nextUsers = snapshot.docs.map((entry) =>
            toDashboardUser(entry.id, entry.data() as Record<string, unknown>)
          );
          setUsers(nextUsers);
          setLoading(false);
          setErrorMessage(null);
          if (nextUsers.length > 0) {
            setAuthWarning(null);
          }
        },
        (error: unknown) => {
          if (!active) return;
          setLoading(false);
          if (error instanceof FirebaseError && error.code === "permission-denied") {
            setErrorMessage(
              "Sem permissao para ler usuarios no Firestore. Ative Anonymous Auth no Firebase Authentication ou faca login com um usuario autorizado."
            );
            return;
          }
          setErrorMessage(
            firebaseErrorMessage(
              error,
              "Nao foi possivel sincronizar a lista de usuarios no Firebase."
            )
          );
        }
      );
    })();

    return () => {
      active = false;
      unsubscribe?.();
    };
  }, []);

  const sortedUsers = useMemo(
    () =>
      [...users].sort((first, second) =>
        first.displayName.localeCompare(second.displayName, "en", {
          sensitivity: "base",
        })
      ),
    [users]
  );

  const groupedUsers = useMemo(() => {
    const grouped: Record<Lane, DashboardUser[]> = {
      riders: [],
      local: [],
      taxi: [],
    };

    sortedUsers.forEach((user) => {
      classifyUser(user).forEach((lane) => {
        grouped[lane].push(user);
      });
    });

    return grouped;
  }, [sortedUsers]);

  const headerUser =
    sortedUsers.find((user) => Boolean(user.photoUrl)) ?? sortedUsers[0] ?? null;

  return (
    <div className="min-h-screen px-5 py-5 lg:px-8">
      <header className="rounded-2xl border border-[#5b4a2d] bg-[linear-gradient(180deg,#2f2f2f_0%,#262626_70%,#222222_100%)] p-3 shadow-[0_18px_40px_-24px_rgba(0,0,0,0.95)]">
        <div className="flex flex-wrap items-center gap-2 md:gap-3">
          <img
            src="/flutter_assets/images/ride_gradient_190_fb9000_fbb125.png"
            alt="Ride"
            className="h-12 w-auto rounded-md"
          />

          <div className="flex items-center gap-2 rounded-full bg-[#171717] px-3 py-2">
            <span className="rounded-full bg-[#2a2a2a] px-3 py-1 text-[10px] uppercase tracking-[0.3em] text-[#d6d6d6]">
              Lifetime
            </span>
            <span className="text-xs text-[#d6d6d6]">Dashboard Snapshot</span>
          </div>

          <div className="flex min-w-[220px] flex-1 items-center gap-2 rounded-full bg-[#151515] px-4 py-2">
            <span className="text-[10px] uppercase tracking-[0.3em] text-[#d6d6d6]">
              Search
            </span>
            <span className="truncate text-xs text-[#8f8f8f]">
              Dashboard Snapshot
            </span>
          </div>

          <nav className="flex flex-wrap items-center gap-2">
            {TOP_NAV_LINKS.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                className="rounded-full bg-[#151515] px-4 py-2 text-xs text-[#d6d6d6] transition hover:bg-[#232323] hover:text-white"
              >
                {item.label}
              </Link>
            ))}
          </nav>

          <span className="rounded-full bg-gradient-to-r from-[#c97200] to-[#fbb125] px-4 py-2 text-xs font-semibold text-black">
            Dark
          </span>
          <span className="rounded-full bg-[#151515] px-4 py-2 text-xs text-[#d6d6d6]">
            User
          </span>
          <div className="flex items-center gap-2 rounded-full bg-[#151515] px-2 py-1.5">
            {headerUser?.photoUrl ? (
              <AvatarImage
                src={headerUser.photoUrl}
                alt={headerUser.displayName}
                className="h-8 w-8 rounded-full object-cover ring-1 ring-white/20"
              />
            ) : (
              <span className="grid h-8 w-8 place-items-center rounded-full bg-[#2a2a2a] text-[#d6d6d6]">
                <UserGlyph />
              </span>
            )}
            <span className="text-xs text-[#d6d6d6]">
              {headerUser?.displayName ?? "User"}
            </span>
          </div>
        </div>
      </header>

      <main className="mt-8 space-y-6 pb-8">
        {authWarning ? (
          <p className="rounded-xl border border-[#56462f] bg-[#2b2419] px-4 py-3 text-sm text-[#f0c47e]">
            {authWarning}
          </p>
        ) : null}

        {errorMessage ? (
          <p className="rounded-xl border border-[#4b3631] bg-[#261d1b] px-4 py-3 text-sm text-[#ffb39f]">
            {errorMessage}
          </p>
        ) : null}

        <div className="grid gap-6 xl:grid-cols-3">
          <UserLane lane="riders" users={groupedUsers.riders} loading={loading} />
          <UserLane lane="local" users={groupedUsers.local} loading={loading} />
          <UserLane lane="taxi" users={groupedUsers.taxi} loading={loading} />
        </div>
      </main>
    </div>
  );
}
