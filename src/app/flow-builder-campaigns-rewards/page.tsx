"use client";

import Link from "next/link";
import { useEffect, useMemo, useRef, useState } from "react";
import { FirebaseError } from "firebase/app";
import {
  addDoc,
  collection,
  doc,
  onSnapshot,
  serverTimestamp,
  updateDoc,
} from "firebase/firestore";

import { ensureFirebaseAuthSession, getFirebaseDb } from "@/lib/firebase/client";

type SponsorPerk = {
  id: string;
  name: string;
  perk: string;
  tier: string;
};

type CampaignData = {
  id: string;
  name: string;
  status: string;
  send: string;
  headline: string;
  pointsRedeemedMtd: string;
  driverCreditsMtd: string;
  flowSteps: string[];
  sponsors: SponsorPerk[];
  riderEarnRate: string;
  driverEarnRate: string;
  redemptionMilestones: string;
  monthlyCaps: string;
  channels: string;
};

type CampaignFirestoreInput = Omit<CampaignData, "id">;

const FLOW_STEPS = [
  "Trigger: On app open (Fri-Sun)",
  "Audience: New riders (30d) in Nassau",
  "Message: In-app 5% off - Start now",
  "A/B Split: A 70% / B 30%  -  Simulate Cost",
  "Wait 5  -  Event name: ride_completed",
  "End branch (track conversion)  -  Send push reminder",
  "Estimated monthly cost: $12,500  -  50k sends",
  "Quiet hours: 22:00 - 08:00  -  Frequency cap per user 2/day",
];

const DEFAULT_SPONSORS: SponsorPerk[] = [
  { id: "sp-rubis", name: "Rubis Weekend Fuel 5%", perk: "Fuel Discount", tier: "Gold" },
  { id: "sp-market", name: "Supermarket 5% Weekday", perk: "Groceries", tier: "Silver" },
  { id: "sp-hotel", name: "Local Gold Hotel 20%", perk: "Hotel", tier: "Gold" },
];

const internalActionRoutes = {
  publish: "/events",
  saveDraft: "/events",
  removeSponsor: "/flow-builder-campaigns-rewards/remove-sponsors",
};

const createId = () => {
  if (typeof crypto !== "undefined" && typeof crypto.randomUUID === "function") {
    return crypto.randomUUID();
  }
  return `${Date.now()}-${Math.floor(Math.random() * 10000)}`;
};

const normalizeText = (value: unknown, fallback: string) => {
  if (typeof value === "string" && value.trim()) return value.trim();
  return fallback;
};

const getFirebaseErrorMessage = (error: unknown, fallback: string) => {
  if (error instanceof FirebaseError) {
    return `${fallback} (${error.code})`;
  }
  return fallback;
};

const normalizeSponsors = (value: unknown): SponsorPerk[] => {
  if (!Array.isArray(value)) return [];
  return value
    .map((entry) => {
      if (typeof entry !== "object" || entry === null) return null;
      const sponsor = entry as Record<string, unknown>;
      return {
        id: normalizeText(sponsor.id, createId()),
        name: normalizeText(sponsor.name, "Unnamed Sponsor"),
        perk: normalizeText(sponsor.perk, "Perk"),
        tier: normalizeText(sponsor.tier, "Bronze"),
      };
    })
    .filter((entry): entry is SponsorPerk => Boolean(entry));
};

const toFirestorePayload = (campaign: CampaignFirestoreInput): CampaignFirestoreInput => ({
  ...campaign,
  sponsors: campaign.sponsors.map((sponsor) => ({
    id: sponsor.id,
    name: sponsor.name.trim(),
    perk: sponsor.perk.trim(),
    tier: sponsor.tier.trim() || "Bronze",
  })),
});

const parseCampaign = (id: string, data: Record<string, unknown>): CampaignData => {
  const sponsors = normalizeSponsors(data.sponsors);
  return {
    id,
    name: normalizeText(data.name, "Campaign"),
    status: normalizeText(data.status, "Draft"),
    send: normalizeText(data.send, "-"),
    headline: normalizeText(data.headline, "Rubis Weekend Promo"),
    pointsRedeemedMtd: normalizeText(data.pointsRedeemedMtd, "860k"),
    driverCreditsMtd: normalizeText(data.driverCreditsMtd, "$4,780"),
    flowSteps: Array.isArray(data.flowSteps)
      ? data.flowSteps
          .map((step) => (typeof step === "string" ? step : ""))
          .filter((step) => step.length > 0)
      : FLOW_STEPS,
    sponsors: sponsors.length ? sponsors : DEFAULT_SPONSORS,
    riderEarnRate: normalizeText(data.riderEarnRate, "200"),
    driverEarnRate: normalizeText(data.driverEarnRate, "50"),
    redemptionMilestones: normalizeText(
      data.redemptionMilestones,
      "50,000 to $5  -  100,000 to $10  -  250,000 to $25"
    ),
    monthlyCaps: normalizeText(
      data.monthlyCaps,
      "Bronze 10 USD  -  Silver 20 USD  -  Gold 30 USD"
    ),
    channels: normalizeText(
      data.channels,
      "In-app  -  Push  -  Email  -  SMS  -  CTA link ride://promo/rubis-weekend"
    ),
  };
};

const createDefaultCampaign = (order: number): CampaignFirestoreInput => ({
  name: order === 1 ? "Rubis Weekend Promo" : `New Campaign ${order}`,
  status: order === 1 ? "Scheduled" : "Draft",
  send: order === 1 ? "Sep 28 10:00" : "-",
  headline: order === 1 ? "Rubis Weekend Promo" : `New Campaign ${order}`,
  pointsRedeemedMtd: "860k",
  driverCreditsMtd: "$4,780",
  flowSteps: FLOW_STEPS,
  sponsors: DEFAULT_SPONSORS.map((sponsor) => ({ ...sponsor, id: createId() })),
  riderEarnRate: "200",
  driverEarnRate: "50",
  redemptionMilestones: "50,000 to $5  -  100,000 to $10  -  250,000 to $25",
  monthlyCaps: "Bronze 10 USD  -  Silver 20 USD  -  Gold 30 USD",
  channels: "In-app  -  Push  -  Email  -  SMS  -  CTA link ride://promo/rubis-weekend",
});

const cloneCampaignForNew = (campaign: CampaignData, order: number): CampaignFirestoreInput => ({
  name: `${campaign.name} Copy ${order}`,
  status: "Draft",
  send: "-",
  headline: `${campaign.name} Copy ${order}`,
  pointsRedeemedMtd: campaign.pointsRedeemedMtd,
  driverCreditsMtd: campaign.driverCreditsMtd,
  flowSteps: [...campaign.flowSteps],
  sponsors: campaign.sponsors.map((sponsor) => ({ ...sponsor, id: createId() })),
  riderEarnRate: campaign.riderEarnRate,
  driverEarnRate: campaign.driverEarnRate,
  redemptionMilestones: campaign.redemptionMilestones,
  monthlyCaps: campaign.monthlyCaps,
  channels: campaign.channels,
});

export default function FlowBuilderCampaignsRewardsPage() {
  const [campaigns, setCampaigns] = useState<CampaignData[]>([]);
  const [loadingCampaigns, setLoadingCampaigns] = useState(true);
  const [isCreatingCampaign, setIsCreatingCampaign] = useState(false);
  const [isSavingSponsors, setIsSavingSponsors] = useState(false);
  const [activeCampaignId, setActiveCampaignId] = useState<string | null>(null);
  const [draftSponsors, setDraftSponsors] = useState<SponsorPerk[]>([]);
  const [sponsorsDirty, setSponsorsDirty] = useState(false);
  const [feedbackMessage, setFeedbackMessage] = useState<string | null>(null);
  const hasSeededCampaignsRef = useRef(false);

  useEffect(() => {
    let active = true;
    let unsubscribe: (() => void) | null = null;

    void (async () => {
      const hasAuth = await ensureFirebaseAuthSession();
      if (!active) return;

      if (!hasAuth) {
        setLoadingCampaigns(false);
        setFeedbackMessage(
          "Nao foi possivel autenticar no Firebase. Ative Anonymous Auth ou faca login para acessar campanhas."
        );
        return;
      }

      const db = getFirebaseDb();
      const campaignsRef = collection(db, "campaignRewards");

      unsubscribe = onSnapshot(
        campaignsRef,
        (snapshot) => {
          if (snapshot.empty && !hasSeededCampaignsRef.current) {
            hasSeededCampaignsRef.current = true;
            void addDoc(campaignsRef, {
              ...toFirestorePayload(createDefaultCampaign(1)),
              createdAt: serverTimestamp(),
              updatedAt: serverTimestamp(),
            }).catch((error: unknown) => {
              setFeedbackMessage(
                getFirebaseErrorMessage(
                  error,
                  "Nao foi possivel criar campanha inicial no Firebase."
                )
              );
            });
            setLoadingCampaigns(false);
            return;
          }

          const nextCampaigns = snapshot.docs
            .map((entry) => parseCampaign(entry.id, entry.data() as Record<string, unknown>))
            .sort((first, second) => first.name.localeCompare(second.name));

          setCampaigns(nextCampaigns);
          setLoadingCampaigns(false);
        },
        (error: unknown) => {
          setLoadingCampaigns(false);
          setFeedbackMessage(
            getFirebaseErrorMessage(error, "Nao foi possivel sincronizar campanhas no Firebase.")
          );
        }
      );
    })();

    return () => {
      active = false;
      unsubscribe?.();
    };
  }, []);

  useEffect(() => {
    if (!campaigns.length) {
      setActiveCampaignId(null);
      setDraftSponsors([]);
      setSponsorsDirty(false);
      return;
    }

    const hasCurrent = campaigns.some((campaign) => campaign.id === activeCampaignId);
    if (!hasCurrent) {
      setActiveCampaignId(campaigns[0].id);
    }
  }, [campaigns, activeCampaignId]);

  const activeCampaignIndex = useMemo(() => {
    const index = campaigns.findIndex((campaign) => campaign.id === activeCampaignId);
    return index >= 0 ? index : 0;
  }, [campaigns, activeCampaignId]);

  const activeCampaign = campaigns[activeCampaignIndex] ?? null;

  useEffect(() => {
    if (!activeCampaign) {
      setDraftSponsors([]);
      setSponsorsDirty(false);
      return;
    }
    setDraftSponsors(activeCampaign.sponsors.map((sponsor) => ({ ...sponsor })));
    setSponsorsDirty(false);
  }, [activeCampaign]);

  const handleCreateCampaign = async () => {
    if (isCreatingCampaign) return;

    const hasAuth = await ensureFirebaseAuthSession();
    if (!hasAuth) {
      setFeedbackMessage(
        "Nao foi possivel autenticar no Firebase. Ative Anonymous Auth ou faca login para criar campanhas."
      );
      return;
    }

    const db = getFirebaseDb();
    const order = campaigns.length + 1;
    const payload = activeCampaign
      ? cloneCampaignForNew(activeCampaign, order)
      : createDefaultCampaign(order);

    setIsCreatingCampaign(true);
    setFeedbackMessage("Criando campanha no Firebase...");
    try {
      const created = await addDoc(collection(db, "campaignRewards"), {
        ...toFirestorePayload(payload),
        createdAt: serverTimestamp(),
        updatedAt: serverTimestamp(),
      });
      setActiveCampaignId(created.id);
      setFeedbackMessage("Nova campanha criada com sucesso.");
    } catch (error: unknown) {
      setFeedbackMessage(getFirebaseErrorMessage(error, "Erro ao criar nova campanha."));
    } finally {
      setIsCreatingCampaign(false);
    }
  };

  const handleSelectCampaign = (campaignId: string) => {
    setActiveCampaignId(campaignId);
  };

  const handlePreviousCampaign = () => {
    if (!campaigns.length) return;
    const nextIndex = activeCampaignIndex === 0 ? campaigns.length - 1 : activeCampaignIndex - 1;
    setActiveCampaignId(campaigns[nextIndex].id);
  };

  const handleNextCampaign = () => {
    if (!campaigns.length) return;
    const nextIndex = activeCampaignIndex === campaigns.length - 1 ? 0 : activeCampaignIndex + 1;
    setActiveCampaignId(campaigns[nextIndex].id);
  };

  const handleAddPerk = () => {
    const sponsorName = window.prompt(
      "Nome do sponsor",
      `Sponsor ${draftSponsors.length + 1}`
    );
    if (!sponsorName) return;

    const perkName = window.prompt("Nome da vantagem (perk)", "New Perk");
    if (!perkName) return;

    const tier = window.prompt("Tier (Bronze / Silver / Gold)", "Bronze") ?? "Bronze";

    setDraftSponsors((current) => [
      ...current,
      { id: createId(), name: sponsorName.trim(), perk: perkName.trim(), tier: tier.trim() || "Bronze" },
    ]);
    setSponsorsDirty(true);
    setFeedbackMessage("Perk adicionada. Clique em Save All Changes para persistir.");
  };

  const handleSponsorFieldChange = (
    sponsorId: string,
    field: keyof SponsorPerk,
    value: string
  ) => {
    setDraftSponsors((current) =>
      current.map((sponsor) =>
        sponsor.id === sponsorId ? { ...sponsor, [field]: value } : sponsor
      )
    );
    setSponsorsDirty(true);
  };

  const handleSaveAllChanges = async () => {
    if (!activeCampaign || isSavingSponsors) return;

    const hasAuth = await ensureFirebaseAuthSession();
    if (!hasAuth) {
      setFeedbackMessage(
        "Nao foi possivel autenticar no Firebase. Ative Anonymous Auth ou faca login para salvar sponsors."
      );
      return;
    }

    setIsSavingSponsors(true);
    setFeedbackMessage("Salvando sponsors e perks no Firebase...");
    try {
      await updateDoc(doc(getFirebaseDb(), "campaignRewards", activeCampaign.id), {
        sponsors: draftSponsors.map((sponsor) => ({
          id: sponsor.id,
          name: sponsor.name.trim() || "Unnamed Sponsor",
          perk: sponsor.perk.trim() || "Perk",
          tier: sponsor.tier.trim() || "Bronze",
        })),
        updatedAt: serverTimestamp(),
      });

      setSponsorsDirty(false);
      setFeedbackMessage("Todas as mudancas de Sponsors & Perks foram salvas.");
    } catch (error: unknown) {
      setFeedbackMessage(getFirebaseErrorMessage(error, "Erro ao salvar Sponsors & Perks."));
    } finally {
      setIsSavingSponsors(false);
    }
  };

  return (
    <div className="min-h-screen px-6 py-8 lg:px-10">
      <section className="space-y-6 pb-12">
        <div className="flex flex-wrap items-center justify-between gap-4">
          <div>
            <p className="text-xs uppercase tracking-[0.3em] text-[var(--text-soft)]">
              Ride  -  Search campaigns  -  Dashboard
            </p>
            <h2 className="text-2xl font-semibold text-white">
              Flow Builder  -  Campaigns  -  Rewards
            </h2>
          </div>
          <div className="flex flex-wrap gap-2 text-xs">
            <button
              type="button"
              onClick={handleCreateCampaign}
              disabled={isCreatingCampaign}
              className="rounded-full bg-gradient-to-r from-[#c97200] to-[#fbb125] px-3 py-2 font-semibold text-black transition hover:brightness-110 disabled:opacity-70"
            >
              {isCreatingCampaign ? "Creating..." : "+ New Campaign"}
            </button>
            <span className="rounded-full bg-[#1f1f1f] px-3 py-2 text-[var(--text-muted)]">
              Dark
            </span>
            <span className="rounded-full bg-[#1f1f1f] px-3 py-2 text-[var(--text-muted)]">
              User
            </span>
          </div>
        </div>

        {feedbackMessage ? (
          <p className="rounded-xl border border-white/10 bg-[#1f1f1f] px-3 py-2 text-xs text-[var(--text-muted)]">
            {feedbackMessage}
          </p>
        ) : null}

        <div className="grid gap-6 lg:grid-cols-[0.9fr_1.2fr_0.9fr]">
          <div className="space-y-3">
            <div className="overflow-hidden rounded-2xl">
              {campaigns.length ? (
                <div
                  className="flex transition-transform duration-300"
                  style={{ transform: `translateX(-${activeCampaignIndex * 100}%)` }}
                >
                  {campaigns.map((campaign) => (
                    <div key={campaign.id} className="min-w-full">
                      <div className="space-y-4 rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
                        <div>
                          <p className="text-xs uppercase tracking-[0.2em] text-[var(--text-soft)]">
                            Campaigns
                          </p>
                          <h3 className="text-lg font-semibold text-white">{campaign.headline}</h3>
                          <p className="text-[10px] text-[var(--text-soft)]">
                            {campaign.status}  -  {campaign.send}
                          </p>
                        </div>
                        <div className="space-y-2 text-xs text-[var(--text-muted)]">
                          {campaigns.map((item) => {
                            const isSelected = item.id === campaign.id;
                            return (
                              <button
                                key={item.id}
                                type="button"
                                onClick={() => handleSelectCampaign(item.id)}
                                className={`flex w-full items-center justify-between rounded-xl px-3 py-2 text-left transition ${
                                  isSelected
                                    ? "bg-[#2f2f2f] text-white"
                                    : "bg-[#1f1f1f] hover:bg-[#2b2b2b]"
                                }`}
                              >
                                <div>
                                  <p className={isSelected ? "text-white" : "text-white/90"}>{item.name}</p>
                                  <p className="text-[10px] text-[var(--text-soft)]">{item.status}</p>
                                </div>
                                <span className="text-[10px]">{item.send}</span>
                              </button>
                            );
                          })}
                        </div>
                        <div className="rounded-xl bg-[#1f1f1f] px-3 py-2 text-[10px] text-[var(--text-soft)]">
                          Active  -  Scheduled  -  Drafts  -  Sent (7d)
                        </div>
                        <div className="grid grid-cols-2 gap-2 text-xs text-[var(--text-muted)]">
                          <div className="rounded-xl bg-[#1f1f1f] px-3 py-2">
                            Points Redeemed (MTD) {campaign.pointsRedeemedMtd}
                          </div>
                          <div className="rounded-xl bg-[#1f1f1f] px-3 py-2">
                            Driver Credits (MTD) {campaign.driverCreditsMtd}
                          </div>
                          <div className="rounded-xl bg-[#1f1f1f] px-3 py-2">
                            Active Perks {campaign.sponsors.length}
                          </div>
                          <div className="rounded-xl bg-[#1f1f1f] px-3 py-2">
                            Total Sponsors {campaign.sponsors.length}
                          </div>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="space-y-4 rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
                  <div>
                    <p className="text-xs uppercase tracking-[0.2em] text-[var(--text-soft)]">
                      Campaigns
                    </p>
                    <h3 className="text-lg font-semibold text-white">No Campaigns Yet</h3>
                  </div>
                  <div className="rounded-xl bg-[#1f1f1f] px-3 py-4 text-xs text-[var(--text-muted)]">
                    Nenhuma campanha no pageview. Clique em + New Campaign para criar a primeira.
                  </div>
                  <div className="rounded-xl bg-[#1f1f1f] px-3 py-2 text-[10px] text-[var(--text-soft)]">
                    Active  -  Scheduled  -  Drafts  -  Sent (7d)
                  </div>
                  <div className="grid grid-cols-2 gap-2 text-xs text-[var(--text-muted)]">
                    <div className="rounded-xl bg-[#1f1f1f] px-3 py-2">Points Redeemed (MTD) -</div>
                    <div className="rounded-xl bg-[#1f1f1f] px-3 py-2">Driver Credits (MTD) -</div>
                    <div className="rounded-xl bg-[#1f1f1f] px-3 py-2">Active Perks 0</div>
                    <div className="rounded-xl bg-[#1f1f1f] px-3 py-2">Total Sponsors 0</div>
                  </div>
                </div>
              )}
            </div>

            <div className="flex items-center justify-between gap-2 rounded-xl border border-white/10 bg-[#2a2a2a] px-3 py-2 text-xs text-[var(--text-muted)]">
              <button
                type="button"
                onClick={handlePreviousCampaign}
                className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
              >
                Prev
              </button>
              <div className="flex gap-2">
                {campaigns.map((campaign, index) => (
                  <button
                    key={campaign.id}
                    type="button"
                    onClick={() => setActiveCampaignId(campaign.id)}
                    className={`h-2 w-2 rounded-full transition ${
                      index === activeCampaignIndex ? "bg-[#fbb125]" : "bg-[#4a4a4a]"
                    }`}
                    aria-label={`Go to campaign ${index + 1}`}
                  />
                ))}
              </div>
              <button
                type="button"
                onClick={handleNextCampaign}
                className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
              >
                Next
              </button>
            </div>

            {loadingCampaigns ? (
              <p className="text-xs text-[var(--text-soft)]">Loading campaigns from Firebase...</p>
            ) : null}
          </div>

          <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
            <p className="text-xs uppercase tracking-[0.2em] text-[var(--text-soft)]">
              Flow Builder
            </p>
            <div className="mt-4 grid gap-3 text-xs text-[var(--text-muted)]">
              {(activeCampaign?.flowSteps ?? FLOW_STEPS).map((step, index) => (
                <div key={`${step}-${index}`} className="rounded-xl bg-[#1f1f1f] px-4 py-3">
                  {step}
                </div>
              ))}
            </div>
            <div className="mt-4 flex flex-wrap gap-2 text-[10px] text-[var(--text-soft)]">
              <span className="rounded-full bg-[#1f1f1f] px-3 py-1">
                Drag a block to a &apos;+&apos; handle to insert
              </span>
              <Link
                href={internalActionRoutes.publish}
                className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
              >
                Publish
              </Link>
              <Link
                href={internalActionRoutes.saveDraft}
                className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
              >
                Save Draft
              </Link>
            </div>
          </div>

          <div className="space-y-4 rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
            <p className="text-xs uppercase tracking-[0.2em] text-[var(--text-soft)]">
              Sponsors & Perks
            </p>
            <div className="space-y-2 text-xs text-[var(--text-muted)]">
              {draftSponsors.map((sponsor) => (
                <div key={sponsor.id} className="rounded-xl bg-[#1f1f1f] px-3 py-2">
                  <div className="grid gap-2">
                    <input
                      value={sponsor.name}
                      onChange={(event) =>
                        handleSponsorFieldChange(sponsor.id, "name", event.target.value)
                      }
                      className="rounded-lg border border-white/10 bg-[#171717] px-2 py-1 text-xs text-white outline-none"
                      placeholder="Sponsor name"
                    />
                    <div className="grid grid-cols-[1fr_auto] gap-2">
                      <input
                        value={sponsor.perk}
                        onChange={(event) =>
                          handleSponsorFieldChange(sponsor.id, "perk", event.target.value)
                        }
                        className="rounded-lg border border-white/10 bg-[#171717] px-2 py-1 text-xs text-white outline-none"
                        placeholder="Perk"
                      />
                      <select
                        value={sponsor.tier}
                        onChange={(event) =>
                          handleSponsorFieldChange(sponsor.id, "tier", event.target.value)
                        }
                        className="rounded-lg border border-white/10 bg-[#171717] px-2 py-1 text-xs text-white outline-none"
                      >
                        <option value="Bronze">Bronze</option>
                        <option value="Silver">Silver</option>
                        <option value="Gold">Gold</option>
                      </select>
                    </div>
                  </div>
                </div>
              ))}
            </div>
            <div className="rounded-xl bg-[#1f1f1f] px-3 py-2 text-[10px] text-[var(--text-soft)]">
              Rider earn rate (pts per USD) {activeCampaign?.riderEarnRate ?? "200"}  -  Driver earn rate (pts per USD GMV){" "}
              {activeCampaign?.driverEarnRate ?? "50"}
            </div>
            <div className="rounded-xl bg-[#1f1f1f] px-3 py-2 text-[10px] text-[var(--text-soft)]">
              Redemption Milestones:{" "}
              {activeCampaign?.redemptionMilestones ??
                "50,000 to $5  -  100,000 to $10  -  250,000 to $25"}
            </div>
            <div className="rounded-xl bg-[#1f1f1f] px-3 py-2 text-[10px] text-[var(--text-soft)]">
              Monthly caps: {activeCampaign?.monthlyCaps ?? "Bronze 10 USD  -  Silver 20 USD  -  Gold 30 USD"}
            </div>
            <div className="rounded-xl bg-[#1f1f1f] px-3 py-2 text-[10px] text-[var(--text-soft)]">
              Channels:{" "}
              {activeCampaign?.channels ??
                "In-app  -  Push  -  Email  -  SMS  -  CTA link ride://promo/rubis-weekend"}
            </div>
            <div className="flex flex-wrap gap-2 text-[10px] text-[var(--text-soft)]">
              <button
                type="button"
                onClick={handleAddPerk}
                className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
              >
                + Add Perk
              </button>
              <Link
                href={internalActionRoutes.removeSponsor}
                className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
              >
                Remove Sponsor
              </Link>
              <button
                type="button"
                onClick={handleSaveAllChanges}
                disabled={!activeCampaign || isSavingSponsors || !sponsorsDirty}
                className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b] disabled:cursor-not-allowed disabled:opacity-60"
              >
                {isSavingSponsors ? "Saving..." : "Save All Changes"}
              </button>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
