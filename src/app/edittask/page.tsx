import Link from "next/link";

const topNavLinks = [
  { label: "Dashboard", href: "/quickysolutionsllcdashboard", active: false },
  { label: "Disputes & Expense", href: "/disputes-expense", active: false },
  { label: "Dispute Resolution", href: "/edittask", active: true },
  {
    label: "Flow Builder, Campaigns & Rewards",
    href: "/flow-builder-campaigns-rewards",
    active: false,
  },
  { label: "Users", href: "/users", active: false },
  { label: "map", href: "/map", active: false },
];

const activityTimeline = [
  "Sep 06 14:12 - Dispute opened by rider",
  "Sep 06 14:15 - Auto-collected GPS and fare log",
  "Sep 06 14:45 - Support assigned: Ana J.",
  "Sep 06 15:30 - Driver responded with route screenshot",
];

const evidenceItems = [
  "Rider message: 'Driver took longer route and AC was off.'",
  "System: GPS path available; fare calculation logged.",
];

const statusFilters = ["Open", "Under Review", "Resolved", "Escalated"];

const buildChatRoute = (name: string, role: string) =>
  `/profile-chat?name=${encodeURIComponent(name)}&role=${encodeURIComponent(
    role
  )}`;

const buildCallRoute = (name: string, role: string) =>
  `/profile-call?name=${encodeURIComponent(name)}&role=${encodeURIComponent(
    role
  )}`;

export default function EditTaskPage() {
  return (
    <main className="min-h-screen px-6 py-8 lg:px-8">
      <div className="mx-auto max-w-[1520px]">
        <header className="flex flex-wrap items-center justify-between gap-4 rounded-2xl border border-white/10 bg-[#2b2b2b]/80 p-4 shadow-[0_16px_40px_-24px_rgba(0,0,0,0.8)]">
          <div className="flex items-center gap-4">
            <img
              src="/flutter_assets/images/ride_gradient_190_fb9000_fbb125.png"
              alt="Ride logo"
              className="h-12 w-auto rounded-lg"
            />
            <div className="hidden items-center gap-2 rounded-full bg-[#1f1f1f] px-3 py-2 text-xs text-[var(--text-muted)] md:flex">
              <span className="rounded-full bg-[#2e2e2e] px-3 py-1 text-[10px] uppercase tracking-[0.2em]">
                Lifetime
              </span>
              <span>Dashboard Snapshot</span>
            </div>
          </div>

          <div className="flex min-w-[300px] flex-1 flex-wrap items-center gap-2 md:justify-center">
            <div className="flex min-w-[260px] flex-1 items-center gap-2 rounded-full bg-[#1f1f1f] px-4 py-2 text-sm text-[var(--text-soft)]">
              <span className="text-xs uppercase tracking-[0.2em] text-[var(--text-muted)]">
                Search
              </span>
              <span className="text-[10px] text-[var(--text-soft)]">
                Dashboard Snapshot
              </span>
            </div>

            {topNavLinks.map((item) => (
              <Link
                key={item.label}
                href={item.href}
                className={[
                  "rounded-full px-3 py-2 text-xs transition",
                  item.active
                    ? "bg-[#fbb125] text-black"
                    : "bg-[#1e1e1e] text-[var(--text-muted)] hover:bg-[#2b2b2b] hover:text-white",
                ].join(" ")}
              >
                {item.label}
              </Link>
            ))}
          </div>

          <div className="flex items-center gap-2">
            <span className="rounded-full bg-gradient-to-r from-[#c97200] to-[#fbb125] px-3 py-2 text-xs font-semibold text-black">
              Dark
            </span>
            <span className="rounded-full bg-[#1f1f1f] px-3 py-2 text-xs text-[var(--text-muted)]">
              User
            </span>
            <div className="flex items-center gap-2 rounded-full bg-[#1f1f1f] px-3 py-2">
              <img
                src="/flutter_assets/images/perfil_transparente_cortado.png"
                alt="Profile"
                className="h-8 w-8 rounded-full border border-white/10"
              />
              <span className="text-xs text-[var(--text-muted)]">Enzo Godoy</span>
            </div>
          </div>
        </header>

        <section className="mt-8 grid gap-6 xl:grid-cols-[1fr_1.08fr]">
          <div className="space-y-5">
            <article className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-5 shadow-[0_18px_36px_-24px_rgba(0,0,0,0.88)]">
              <p className="text-4xl leading-none text-white">Selected Dispute: D-10922</p>
              <div className="mt-4 space-y-2 text-lg text-[#d8d8d8]">
                <p>Rider: Enzo G. (4.9) Driver: Sam M. (4.7)</p>
                <p>Category: Payment Amount: $12.40 Date: Sep 06 14:12</p>
                <p>Ride: Airport -&gt; Downtown Route deviation claim</p>
              </div>

              <p className="mt-5 text-3xl text-[#a8a8a8]">Evidence</p>
              <div className="mt-3 rounded-xl bg-[#121212] px-4 py-3 text-lg text-[#d8d8d8]">
                {evidenceItems.map((item) => (
                  <p key={item} className="leading-[1.5]">
                    - {item}
                  </p>
                ))}
              </div>
            </article>

            <article className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-5 shadow-[0_18px_36px_-24px_rgba(0,0,0,0.88)]">
              <p className="text-4xl leading-none text-white">Resolution Notes</p>

              <textarea
                placeholder="Type notes here..."
                className="mt-4 h-[130px] w-full resize-none rounded-xl border border-white/10 bg-[#121212] px-4 py-3 text-lg text-[#d8d8d8] outline-none placeholder:text-[#6b6f78]"
              />

              <p className="mt-3 text-3xl text-[#a8a8a8]">Refund Amount (optional)</p>
              <input
                type="text"
                defaultValue="$0.00"
                aria-label="Refund amount"
                className="mt-2 h-12 w-full max-w-[230px] rounded-lg border border-white/10 bg-[#121212] px-4 text-2xl text-[#d8d8d8] outline-none"
              />

              <p className="mt-3 text-3xl text-[#a8a8a8]">Outcome</p>
              <div className="mt-2 flex flex-wrap gap-3 text-lg">
                <button
                  type="button"
                  className="min-w-[230px] rounded-full bg-[#16b047] px-5 py-2.5 font-semibold text-[#0f1711] transition hover:brightness-110"
                >
                  Resolve - no refund
                </button>
                <button
                  type="button"
                  className="min-w-[190px] rounded-full bg-[#fbb125] px-5 py-2.5 text-black transition hover:brightness-110"
                >
                  Refund rider
                </button>
                <button
                  type="button"
                  className="min-w-[150px] rounded-full bg-[#ff4d5f] px-5 py-2.5 text-white transition hover:brightness-110"
                >
                  Escalate
                </button>
              </div>

              <div className="mt-7 grid gap-2 sm:grid-cols-2 lg:grid-cols-4">
                <Link
                  href={buildChatRoute("Sam Miller", "Driver")}
                  className="rounded-full bg-[#171717] px-4 py-2 text-center text-2xl italic leading-none text-white transition hover:bg-[#262626]"
                >
                  Text Sam
                </Link>
                <Link
                  href={buildCallRoute("Sam Miller", "Driver")}
                  className="rounded-full bg-[#ececec] px-4 py-2 text-center text-2xl italic leading-none text-[#191919] transition hover:bg-white"
                >
                  Call Sam
                </Link>
                <Link
                  href={buildChatRoute("Enzo Godoy", "Rider")}
                  className="rounded-full bg-[#171717] px-4 py-2 text-center text-2xl italic leading-none text-white transition hover:bg-[#262626]"
                >
                  Text Enzo
                </Link>
                <Link
                  href={buildCallRoute("Enzo Godoy", "Rider")}
                  className="rounded-full bg-[#fbb125] px-4 py-2 text-center text-2xl italic leading-none text-black transition hover:brightness-110"
                >
                  Call Enzo
                </Link>
              </div>
            </article>
          </div>

          <article className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-5 shadow-[0_18px_36px_-24px_rgba(0,0,0,0.88)]">
            <p className="text-4xl leading-none text-white">Activity Timeline</p>
            <div className="mt-4 space-y-2">
              {activityTimeline.map((item) => (
                <p
                  key={item}
                  className="rounded-lg border border-white/5 bg-[#121212] px-4 py-3 text-lg text-[#d8d8d8]"
                >
                  {item}
                </p>
              ))}
            </div>

            <p className="mt-3 text-4xl leading-none text-white">Assignment</p>
            <p className="mt-3 rounded-lg border border-white/5 bg-[#121212] px-4 py-3 text-lg text-[#d8d8d8]">
              Assignee: Ana Jones
            </p>

            <button
              type="button"
              className="mt-3 min-w-[190px] rounded-full bg-[#fbb125] px-5 py-2.5 text-lg text-black transition hover:brightness-110"
            >
              Reassign
            </button>

            <div className="mt-4 flex flex-wrap items-center justify-between gap-2 rounded-xl border border-white/10 bg-[#232323] px-4 py-3">
              <p className="text-base text-[#a8a8a8]">
                Filters: {statusFilters.join(" | ")}
              </p>
              <button
                type="button"
                className="rounded-full bg-[#fbb125] px-12 py-2 text-sm text-black transition hover:brightness-110"
              >
                Export CSV
              </button>
            </div>

            <p className="mt-3 text-4xl leading-none text-white">
              Chat with Driver and Rider
            </p>
            <div className="mt-3 rounded-2xl border border-white/10 bg-[#171717] px-4 py-3">
              <div className="h-[190px] rounded-xl bg-[#101010] px-4 py-3 text-sm text-[#7d8494]">
                <p>hi help</p>
                <p className="mt-20 text-right">dw i got you</p>
              </div>
              <input
                type="text"
                placeholder="Type here........."
                aria-label="Chat input"
                className="mt-3 h-12 w-full rounded-full border border-white/10 bg-[#d6d9df] px-5 text-sm text-[#2e323b] outline-none placeholder:text-[#7a808a]"
              />
            </div>
          </article>
        </section>
      </div>
    </main>
  );
}
