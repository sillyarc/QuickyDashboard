"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { User, onAuthStateChanged } from "firebase/auth";
import { collection, doc, getDoc, getDocs, limit, query, where } from "firebase/firestore";

import ChatPanel from "@/components/ChatPanel";
import { getFirebaseAuth, getFirebaseDb } from "@/lib/firebase/client";

type ProfileChatClientProps = {
  initialName?: string;
  initialRole?: string;
  userId?: string;
  uid?: string;
  phone?: string;
};

const DEFAULT_NAME = "Perfil";
const DEFAULT_ROLE = "Usuário";

type FirebaseProfile = {
  name?: string;
  role?: string;
  phone?: string;
};

const cleanText = (value?: string | null) => {
  const text = value?.trim();
  return text ? text : undefined;
};

const sanitizePhone = (value?: string) => value?.replace(/[^\d+]/g, "");

const isDefaultName = (value?: string) => {
  const normalized = value?.trim().toLowerCase();
  return !normalized || normalized === "perfil";
};

const isDefaultRole = (value?: string) => {
  const normalized = value?.trim().toLowerCase();
  return !normalized || normalized === "usuário" || normalized === "usuario";
};

const readProfileFromDoc = (
  data: Record<string, unknown> | undefined
): FirebaseProfile | null => {
  if (!data) return null;
  const name = cleanText(
    (data.display_name as string | undefined) ??
      (data.displayName as string | undefined) ??
      (data.name as string | undefined)
  );
  const role = cleanText(
    (data.taskOrTaskee as string | undefined) ??
      (data.role as string | undefined) ??
      (data.status as string | undefined)
  );
  const phone = cleanText(
    (data.phone_number as string | undefined) ??
      (data.phoneNumber as string | undefined) ??
      (data.phone as string | undefined)
  );
  if (!name && !role && !phone) return null;
  return { name, role, phone };
};

const fetchProfileFromFirebase = async ({
  userId,
  uid,
  email,
}: {
  userId?: string;
  uid?: string;
  email?: string;
}): Promise<FirebaseProfile | null> => {
  const db = getFirebaseDb();

  const tryDoc = async (id?: string) => {
    const cleanId = cleanText(id);
    if (!cleanId) return null;
    const snap = await getDoc(doc(db, "users", cleanId));
    return snap.exists()
      ? readProfileFromDoc(snap.data() as Record<string, unknown>)
      : null;
  };

  const byDocId = await tryDoc(userId);
  if (byDocId) return byDocId;

  const byUidDoc = await tryDoc(uid);
  if (byUidDoc) return byUidDoc;

  const cleanUid = cleanText(uid);
  if (cleanUid) {
    const uidQuery = query(
      collection(db, "users"),
      where("uid", "==", cleanUid),
      limit(1)
    );
    const uidResult = await getDocs(uidQuery);
    const match = uidResult.docs[0];
    if (match) {
      const profile = readProfileFromDoc(match.data() as Record<string, unknown>);
      if (profile) return profile;
    }
  }

  const cleanEmail = cleanText(email);
  if (cleanEmail) {
    const emailQuery = query(
      collection(db, "users"),
      where("email", "==", cleanEmail),
      limit(1)
    );
    const emailResult = await getDocs(emailQuery);
    const match = emailResult.docs[0];
    if (match) {
      const profile = readProfileFromDoc(match.data() as Record<string, unknown>);
      if (profile) return profile;
    }
  }

  return null;
};

export default function ProfileChatClient({
  initialName,
  initialRole,
  userId,
  uid,
  phone,
}: ProfileChatClientProps) {
  const [name, setName] = useState(cleanText(initialName) ?? DEFAULT_NAME);
  const [role, setRole] = useState(cleanText(initialRole) ?? DEFAULT_ROLE);
  const [phoneValue, setPhoneValue] = useState(cleanText(phone));

  const shouldResolveName = isDefaultName(initialName);
  const shouldResolveRole = isDefaultRole(initialRole);
  const shouldResolvePhone = !cleanText(phone);

  useEffect(() => {
    let active = true;
    let unsubAuth: (() => void) | undefined;

    const applyProfile = (profile: FirebaseProfile | null) => {
      if (!active || !profile) return;
      if (shouldResolveName && profile.name) setName(profile.name);
      if (shouldResolveRole && profile.role) setRole(profile.role);
      if (shouldResolvePhone && profile.phone) setPhoneValue(profile.phone);
    };

    const resolveFromFirebase = async (authUser?: User | null) => {
      const profile = await fetchProfileFromFirebase({
        userId,
        uid: cleanText(uid) ?? authUser?.uid,
        email: authUser?.email ?? undefined,
      });
      applyProfile(profile);
    };

    const auth = getFirebaseAuth();
    void resolveFromFirebase(auth?.currentUser);

    if (auth && !auth.currentUser) {
      unsubAuth = onAuthStateChanged(auth, (authUser) => {
        unsubAuth?.();
        void resolveFromFirebase(authUser);
      });
    }

    return () => {
      active = false;
      unsubAuth?.();
    };
  }, [phone, shouldResolveName, shouldResolvePhone, shouldResolveRole, uid, userId]);

  const sanitizedPhone = sanitizePhone(phoneValue);
  const canCall = Boolean(sanitizedPhone);

  return (
    <div className="min-h-screen px-6 py-8 lg:px-10">
      <header className="flex flex-wrap items-center justify-between gap-4 rounded-2xl border border-white/10 bg-[#2b2b2b]/80 p-4 shadow-[0_16px_40px_-24px_rgba(0,0,0,0.8)]">
        <div>
          <p className="text-xs uppercase tracking-[0.3em] text-[var(--text-soft)]">
            Conversa
          </p>
          <h1 className="text-2xl font-semibold text-white">{name}</h1>
          <p className="text-xs text-[var(--text-muted)]">{role}</p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <Link
            href="/quickysolutionsllcdashboard"
            className="rounded-full bg-[#1f1f1f] px-3 py-2 text-xs text-[var(--text-muted)] transition hover:bg-[#2b2b2b] hover:text-white"
          >
            Voltar ao painel
          </Link>
          {canCall ? (
            <a
              href={`tel:${sanitizedPhone}`}
              className="rounded-full bg-gradient-to-r from-[#c97200] to-[#fbb125] px-3 py-2 text-xs font-semibold text-black transition hover:brightness-110"
            >
              Ligar agora
            </a>
          ) : (
            <span className="rounded-full bg-[#1f1f1f] px-3 py-2 text-xs text-[var(--text-muted)]">
              Telefone indisponível
            </span>
          )}
        </div>
      </header>

      <main className="mt-8 grid gap-6 lg:grid-cols-[1.3fr_0.7fr]">
        <ChatPanel contactName={name} />
        <aside className="space-y-4">
          <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
            <p className="text-sm font-semibold text-white">Detalhes do perfil</p>
            <div className="mt-3 space-y-2 text-xs text-[var(--text-muted)]">
              <p>
                Nome: <span className="text-white">{name}</span>
              </p>
              <p>
                Função: <span className="text-white">{role}</span>
              </p>
              <p>Canal: Chat direto no painel</p>
            </div>
          </div>
          <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4 text-xs text-[var(--text-muted)]">
            <p className="text-white">Atalho rápido</p>
            <p className="mt-2">
              Você pode registrar o histórico completo do chat ao integrar o
              Firebase ou outro serviço de mensagens em tempo real.
            </p>
          </div>
        </aside>
      </main>
    </div>
  );
}
