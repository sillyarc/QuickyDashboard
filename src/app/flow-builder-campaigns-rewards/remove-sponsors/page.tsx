"use client";

import Link from "next/link";
import { useEffect, useRef, useState } from "react";
import { FirebaseError } from "firebase/app";
import { addDoc, collection, deleteDoc, doc, onSnapshot, serverTimestamp } from "firebase/firestore";

import { ensureFirebaseAuthSession, getFirebaseDb } from "@/lib/firebase/client";

type RemovableSponsor = {
  id: string;
  name: string;
  category: string;
  tier: string;
};

const RANDOM_SPONSOR_POOL = [
  { name: "Nassau Fuel Co.", category: "Fuel", tier: "Gold" },
  { name: "Coral Market", category: "Groceries", tier: "Silver" },
  { name: "Blue Lagoon Hotel", category: "Hotel", tier: "Gold" },
  { name: "Atlantic Mobile", category: "Telecom", tier: "Silver" },
  { name: "Island Wheels", category: "Auto", tier: "Bronze" },
  { name: "Caribbean Eats", category: "Food", tier: "Bronze" },
  { name: "Sunset Airlines", category: "Travel", tier: "Gold" },
  { name: "Tropic Bank", category: "Finance", tier: "Silver" },
];

const OBAMA_SPONSOR = {
  name: "Barack Obama Foundation",
  category: "Social Impact",
  tier: "Gold",
};

const getFirebaseErrorMessage = (error: unknown, fallback: string) => {
  if (error instanceof FirebaseError) {
    return `${fallback} (${error.code})`;
  }
  return fallback;
};

const pickRandomSponsors = (count: number) => {
  const copy = [...RANDOM_SPONSOR_POOL];
  for (let index = copy.length - 1; index > 0; index -= 1) {
    const randomIndex = Math.floor(Math.random() * (index + 1));
    const temp = copy[index];
    copy[index] = copy[randomIndex];
    copy[randomIndex] = temp;
  }
  return copy.slice(0, count);
};

const seedInitialSponsors = async () => {
  const db = getFirebaseDb();
  const removableSponsorsRef = collection(db, "removableSponsors");
  const seeds = [OBAMA_SPONSOR, ...pickRandomSponsors(4)];

  await Promise.all(
    seeds.map((sponsor) =>
      addDoc(removableSponsorsRef, {
        ...sponsor,
        createdAt: serverTimestamp(),
        updatedAt: serverTimestamp(),
      })
    )
  );
};

export default function RemoveSponsorsPage() {
  const [sponsors, setSponsors] = useState<RemovableSponsor[]>([]);
  const [loading, setLoading] = useState(true);
  const [statusMessage, setStatusMessage] = useState<string | null>(null);
  const [removingId, setRemovingId] = useState<string | null>(null);
  const didSeedRef = useRef(false);

  useEffect(() => {
    let active = true;
    let unsubscribe: (() => void) | null = null;

    void (async () => {
      const hasAuth = await ensureFirebaseAuthSession();
      if (!active) return;

      if (!hasAuth) {
        setLoading(false);
        setStatusMessage(
          "Nao foi possivel autenticar no Firebase. Ative Anonymous Auth ou faca login para acessar patrocinadores."
        );
        return;
      }

      const db = getFirebaseDb();
      const removableSponsorsRef = collection(db, "removableSponsors");

      unsubscribe = onSnapshot(
        removableSponsorsRef,
        (snapshot) => {
          const nextSponsors = snapshot.docs
            .map((entry) => {
              const data = entry.data() as Record<string, unknown>;
              return {
                id: entry.id,
                name:
                  typeof data.name === "string" && data.name.trim()
                    ? data.name.trim()
                    : "Unnamed Sponsor",
                category:
                  typeof data.category === "string" && data.category.trim()
                    ? data.category.trim()
                    : "Unknown",
                tier:
                  typeof data.tier === "string" && data.tier.trim() ? data.tier.trim() : "Bronze",
              } as RemovableSponsor;
            })
            .sort((first, second) => first.name.localeCompare(second.name));

          setSponsors(nextSponsors);
          setLoading(false);

          if (!snapshot.empty || didSeedRef.current) return;

          didSeedRef.current = true;
          setStatusMessage("Criando 5 patrocinadores iniciais no Firebase...");
          void seedInitialSponsors()
            .then(() => {
              setStatusMessage("Patrocinios iniciais criados.");
            })
            .catch((error: unknown) => {
              setStatusMessage(
                getFirebaseErrorMessage(error, "Erro ao criar patrocinadores iniciais.")
              );
            });
        },
        (error: unknown) => {
          setLoading(false);
          setStatusMessage(
            getFirebaseErrorMessage(error, "Erro ao sincronizar patrocinadores.")
          );
        }
      );
    })();

    return () => {
      active = false;
      unsubscribe?.();
    };
  }, []);

  const handleRemoveSponsor = async (sponsorId: string) => {
    if (removingId) return;

    const hasAuth = await ensureFirebaseAuthSession();
    if (!hasAuth) {
      setStatusMessage(
        "Nao foi possivel autenticar no Firebase. Ative Anonymous Auth ou faca login para remover patrocinadores."
      );
      return;
    }

    setRemovingId(sponsorId);
    setStatusMessage("Removendo patrocinio no Firebase...");
    try {
      await deleteDoc(doc(getFirebaseDb(), "removableSponsors", sponsorId));
      setStatusMessage("Patrocinio removido com sucesso.");
    } catch (error: unknown) {
      setStatusMessage(
        getFirebaseErrorMessage(error, "Nao foi possivel remover o patrocinio.")
      );
    } finally {
      setRemovingId(null);
    }
  };

  return (
    <div className="min-h-screen px-6 py-8 lg:px-10">
      <section className="mx-auto w-full max-w-4xl space-y-6 pb-12">
        <header className="flex flex-wrap items-center justify-between gap-3">
          <div>
            <p className="text-xs uppercase tracking-[0.3em] text-[var(--text-soft)]">
              Flow Builder  -  Campaigns  -  Rewards
            </p>
            <h1 className="text-2xl font-semibold text-white">Remove Sponsors</h1>
          </div>
          <Link
            href="/flow-builder-campaigns-rewards"
            className="rounded-full bg-[#1f1f1f] px-3 py-2 text-xs text-[var(--text-muted)] transition hover:bg-[#2b2b2b] hover:text-white"
          >
            Back to Campaigns
          </Link>
        </header>

        {statusMessage ? (
          <p className="rounded-xl border border-white/10 bg-[#1f1f1f] px-3 py-2 text-xs text-[var(--text-muted)]">
            {statusMessage}
          </p>
        ) : null}

        <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
          <p className="text-xs uppercase tracking-[0.2em] text-[var(--text-soft)]">
            Removable Sponsors
          </p>

          {loading ? <p className="mt-3 text-xs text-[var(--text-muted)]">Loading from Firebase...</p> : null}

          {!loading && !sponsors.length ? (
            <p className="mt-3 text-xs text-[var(--text-muted)]">
              Nenhum patrocinio disponivel para remover.
            </p>
          ) : null}

          <div className="mt-4 space-y-2 text-xs text-[var(--text-muted)]">
            {sponsors.map((sponsor) => (
              <div
                key={sponsor.id}
                className="flex flex-wrap items-center justify-between gap-2 rounded-xl bg-[#1f1f1f] px-3 py-2"
              >
                <div>
                  <p className="text-sm text-white">{sponsor.name}</p>
                  <p className="text-[10px] text-[var(--text-soft)]">
                    {sponsor.category}  -  {sponsor.tier}
                  </p>
                </div>
                <button
                  type="button"
                  onClick={() => handleRemoveSponsor(sponsor.id)}
                  disabled={Boolean(removingId)}
                  className="rounded-full bg-[#3a1f1f] px-3 py-1 text-[10px] text-[#ffb3b3] transition hover:brightness-110 disabled:opacity-60"
                >
                  {removingId === sponsor.id ? "Removing..." : "Remove"}
                </button>
              </div>
            ))}
          </div>
        </div>
      </section>
    </div>
  );
}
