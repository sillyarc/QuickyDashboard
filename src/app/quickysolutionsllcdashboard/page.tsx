import Link from "next/link";
import SosEmergencyCard from "@/components/SosEmergencyCard";

const kpiCards = [
  {
    title: "Runway",
    value: "36 mo",
    note: "Revenue at 90k/yr expenses at 12,000",
    delta: "->",
  },
  {
    title: "Expenses",
    value: "$ 12,000",
    note: "Total Expenses (MTD)",
    delta: "down",
  },
  { title: "Drivers", value: "350", note: "Drivers", delta: "up" },
  { title: "Taxi Drivers", value: "350", note: "Taxi Drivers", delta: "up" },
  { title: "Customers", value: "20,032", note: "Customers", delta: "up" },
  {
    title: "Rides",
    value: "350",
    note: "120 + From last Month",
    delta: "up",
  },
  {
    title: "Growth",
    value: "25%",
    note: "5% - from last month",
    delta: "down",
  },
  {
    title: "Revenue",
    value: "$1,000,000",
    note: "$1,200 + From last Month",
    delta: "up",
  },
];

const quickStats = [
  { label: "Churn", value: "25.4 %", delta: "+ 3%" },
  { label: "ARPD", value: "150", delta: "+ 4%" },
  { label: "Returning User %", value: "62.1 %", delta: "+ 5%" },
  { label: "AVG time on the APP", value: "04:36", delta: "+ 15%" },
];


const campaignList = [
  { name: "Rubis Weekend Fuel 5%", status: "Scheduled", send: "Sep 28 10:00" },
  { name: "Airport Welcome Promo", status: "Active", send: "Now" },
  { name: "Dormant Winback 10 USD", status: "Draft", send: "-" },
  { name: "Supermarket 5% Weekday", status: "Active", send: "Now" },
  { name: "Local Gold Hotel 20%", status: "Draft", send: "-" },
];

const sponsors = [
  { name: "Rubis Weekend Fuel 5%", perk: "Fuel Discount", tier: "Gold" },
  { name: "Supermarket 5% Weekday", perk: "Groceries", tier: "Silver" },
  { name: "Local Gold Hotel 20%", perk: "Hotel", tier: "Gold" },
];

const topNavLinks = [
  { label: "Dashboard", href: "/quickysolutionsllcdashboard" },
  { label: "Disputes & Expense", href: "/disputes-expense" },
  { label: "Dispute Resolution", href: "/edittask" },
  { label: "Flow Builder", href: "/events" },
  { label: "Campaigns", href: "/appAnalystics" },
  { label: "Rewards", href: "/taskspreprontas" },
];

const internalActionRoutes = {
  askDrivers: "/alluserapage",
  userLocation: "/quickyTestRealTime",
  resolveDispute: "/edittask",
  refundRider: "/edittask",
  escalateDispute: "/edittask",
  addEmployee: "/createPreTasks",
  payrollEmployees: "/alluserapage",
  newExpense: "/dashboardQuickyTasks",
  addExpense: "/dashboardQuickyTasks",
  setRecurring: "/dashboardQuickyTasksCopyCopy",
  importCsv: "/createPreTasksCopy",
  exportCsv: "/appAnalystics",
  newCampaign: "/events",
  campaigns: "/appAnalystics",
  publish: "/events",
  saveDraft: "/events",
  addPerk: "/taskspreprontas",
  removeSponsor: "/edittask",
  saveAllChanges: "/events",
};

const buildChatRoute = (name: string, role: string) =>
  `/profile-chat?name=${encodeURIComponent(name)}&role=${encodeURIComponent(
    role
  )}`;

export default function QuickySolutionsDashboardPage() {
  return (
    <div className="min-h-screen px-6 py-8 lg:px-10">
      <header className="flex flex-wrap items-center justify-between gap-6 rounded-2xl border border-white/10 bg-[#2b2b2b]/80 p-4 shadow-[0_16px_40px_-24px_rgba(0,0,0,0.8)]">
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

        <div className="flex flex-1 flex-wrap items-center gap-2 md:justify-center">
          <div className="flex min-w-[240px] flex-1 items-center gap-2 rounded-full bg-[#1f1f1f] px-4 py-2 text-sm text-[var(--text-soft)]">
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
              className="rounded-full bg-[#1e1e1e] px-3 py-2 text-xs text-[var(--text-muted)] transition hover:bg-[#2b2b2b] hover:text-white"
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

      <main className="mt-8 space-y-10">
        <section className="space-y-6">
          <div className="flex flex-wrap items-end justify-between gap-4">
            <div>
              <p className="text-xs uppercase tracking-[0.3em] text-[var(--text-soft)]">
                Dashboard Snapshot
              </p>
              <h1 className="text-3xl font-semibold text-white">
                Select User Dashboard Snapshot
              </h1>
              <p className="mt-2 text-sm text-[var(--text-muted)]">
                Riders  -  Local Driver  -  Taxi Driver
              </p>
            </div>
            <div className="flex flex-wrap items-center gap-3">
              <span className="rounded-full bg-[#232323] px-4 py-2 text-xs text-[var(--text-soft)]">
                Status: Avaiable
              </span>
              <span className="rounded-full bg-[#232323] px-4 py-2 text-xs text-[var(--text-soft)]">
                Taxi Drivers  -  Drivers  -  Clients
              </span>
            </div>
          </div>

          <div className="grid gap-6 lg:grid-cols-[1.2fr_0.9fr]">
            <div className="grid gap-6 md:grid-cols-2">
              <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
                <div className="flex items-start justify-between">
                  <div className="flex items-center gap-3">
                    <img
                      src="/flutter_assets/images/perfil_transparente_cortado.png"
                      alt="Rider"
                      className="h-12 w-12 rounded-full border border-white/10"
                    />
                    <div>
                      <p className="text-sm font-semibold text-white">
                        Enzo Godoy
                      </p>
                      <p className="text-xs text-[var(--text-muted)]">
                        Rider Rating:
                      </p>
                    </div>
                  </div>
                  <span className="rounded-full bg-[#1c1c1c] px-3 py-1 text-xs text-[var(--text-muted)]">
                    # of Rides: 30
                  </span>
                </div>
                <div className="mt-4 space-y-2 text-xs text-[var(--text-muted)]">
                  <p>Where From United States, Florida</p>
                  <p>Passport #: GB882306</p>
                  <p>Age: 19  -  Gender: Female</p>
                  <p>Ethinicity: white</p>
                  <p>Emergency contact: Mari [Mom]: (305) 850-0987</p>
                </div>
                <div className="mt-4 flex flex-wrap gap-2">
                  <Link
                    href={buildChatRoute("Enzo Godoy", "Rider")}
                    className="rounded-full bg-[#1f1f1f] px-3 py-1 text-[10px] text-[var(--text-soft)] transition hover:bg-[#2b2b2b]"
                  >
                    Text Sam
                  </Link>
                  <a
                    href="tel:+13058500987"
                    className="rounded-full bg-[#1f1f1f] px-3 py-1 text-[10px] text-[var(--text-soft)] transition hover:bg-[#2b2b2b]"
                  >
                    Call Sam
                  </a>
                </div>
              </div>

              <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
                <div className="flex items-start justify-between">
                  <div className="flex items-center gap-3">
                    <img
                      src="/flutter_assets/images/25164.jpg"
                      alt="Driver"
                      className="h-12 w-12 rounded-full border border-white/10 object-cover"
                    />
                    <div>
                      <p className="text-sm font-semibold text-white">
                        Sam Miller - Taxi Driver
                      </p>
                      <p className="text-xs text-[var(--text-muted)]">
                        Driver Rating:
                      </p>
                    </div>
                  </div>
                  <span className="rounded-full bg-[#1c1c1c] px-3 py-1 text-xs text-[var(--text-muted)]">
                    30 Rides
                  </span>
                </div>
                <div className="mt-4 space-y-2 text-xs text-[var(--text-muted)]">
                  <p>Car Driving: Nissan Serena</p>
                  <p>Rides this month: 132  -  Total: 400</p>
                  <p>From US, Florida</p>
                </div>
                <div className="mt-4 flex flex-wrap gap-2">
                  <Link
                    href={buildChatRoute("Sam Miller", "Taxi Driver")}
                    className="rounded-full bg-[#1f1f1f] px-3 py-1 text-[10px] text-[var(--text-soft)] transition hover:bg-[#2b2b2b]"
                  >
                    Text Sam
                  </Link>
                  <a
                    href="tel:+13055550199"
                    className="rounded-full bg-[#1f1f1f] px-3 py-1 text-[10px] text-[var(--text-soft)] transition hover:bg-[#2b2b2b]"
                  >
                    Call Sam
                  </a>
                </div>
              </div>

              <SosEmergencyCard
                askDriversHref={internalActionRoutes.askDrivers}
                fallbackUserLocationHref={internalActionRoutes.userLocation}
              />
            </div>

            <div className="space-y-6">
              <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
                <p className="text-sm font-semibold text-white">Quick Stats</p>
                <div className="mt-4 grid gap-4">
                  {quickStats.map((stat) => (
                    <div
                      key={stat.label}
                      className="flex items-center justify-between rounded-xl bg-[#1f1f1f] px-4 py-3 text-xs text-[var(--text-muted)]"
                    >
                      <div>
                        <p className="text-[10px] uppercase tracking-[0.2em]">
                          {stat.label}
                        </p>
                        <p className="mt-1 text-lg text-white">{stat.value}</p>
                      </div>
                      <span className="rounded-full bg-[#141414] px-3 py-1 text-[10px] text-[#98f0b2]">
                        {stat.delta}
                      </span>
                    </div>
                  ))}
                </div>
                <div className="mt-4 text-xs text-[var(--text-soft)]">
                  AVG time on the APP Rider  -  AVG time on the APP Driver
                </div>
              </div>

              <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
                <div className="flex items-center justify-between">
                  <p className="text-sm font-semibold text-white">Users</p>
                  <span className="text-xs text-[var(--text-muted)]">
                    Locals  -  Tourists
                  </span>
                </div>
                <div className="mt-4 grid gap-3 text-xs text-[var(--text-muted)]">
                  <div className="flex items-center justify-between rounded-xl bg-[#1f1f1f] px-4 py-3">
                    <span>Locals</span>
                    <span className="text-white">150</span>
                  </div>
                  <div className="flex items-center justify-between rounded-xl bg-[#1f1f1f] px-4 py-3">
                    <span>Tourists</span>
                    <span className="text-white">120</span>
                  </div>
                  <div className="rounded-xl bg-[#1f1f1f] px-4 py-3">
                    Jan  -  Feb  -  Mar  -  Apr  -  May  -  Jun
                  </div>
                  <div className="rounded-xl bg-[#1f1f1f] px-4 py-3">
                    Lorem ipsum  -  ARPU
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="flex gap-3 overflow-x-auto pb-2">
            {kpiCards.map((card) => (
              <div
                key={card.title}
                className="min-w-[220px] rounded-2xl border border-white/10 bg-[#2a2a2a] p-4 shadow-[0_10px_30px_-22px_rgba(0,0,0,0.7)]"
              >
                <p className="text-xs uppercase tracking-[0.2em] text-[var(--text-soft)]">
                  {card.title}
                </p>
                <p className="mt-2 text-lg font-semibold text-white">
                  {card.value}
                </p>
                <p className="mt-2 text-xs text-[var(--text-muted)]">
                  {card.note}
                </p>
                <span className="mt-3 inline-flex items-center rounded-full bg-[#1f1f1f] px-3 py-1 text-[10px] text-[var(--text-soft)]">
                  {card.delta}
                </span>
              </div>
            ))}
          </div>
        </section>

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
              <Link
                href={internalActionRoutes.newCampaign}
                className="rounded-full bg-gradient-to-r from-[#c97200] to-[#fbb125] px-3 py-2 font-semibold text-black transition hover:brightness-110"
              >
                + New Campaign
              </Link>
              <Link
                href={internalActionRoutes.campaigns}
                className="rounded-full bg-[#1f1f1f] px-3 py-2 text-[var(--text-muted)] transition hover:bg-[#2b2b2b] hover:text-white"
              >
                Campaigns
              </Link>
              <span className="rounded-full bg-[#1f1f1f] px-3 py-2 text-[var(--text-muted)]">
                Dark
              </span>
              <span className="rounded-full bg-[#1f1f1f] px-3 py-2 text-[var(--text-muted)]">
                User
              </span>
            </div>
          </div>

          <div className="grid gap-6 lg:grid-cols-[0.9fr_1.2fr_0.9fr]">
            <div className="space-y-4 rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
              <div>
                <p className="text-xs uppercase tracking-[0.2em] text-[var(--text-soft)]">
                  Campaigns
                </p>
                <h3 className="text-lg font-semibold text-white">
                  Rubis Weekend Promo
                </h3>
              </div>
              <div className="space-y-2 text-xs text-[var(--text-muted)]">
                {campaignList.map((campaign) => (
                  <div
                    key={campaign.name}
                    className="flex items-center justify-between rounded-xl bg-[#1f1f1f] px-3 py-2"
                  >
                    <div>
                      <p className="text-white">{campaign.name}</p>
                      <p className="text-[10px] text-[var(--text-soft)]">
                        {campaign.status}
                      </p>
                    </div>
                    <span className="text-[10px]">{campaign.send}</span>
                  </div>
                ))}
              </div>
              <div className="rounded-xl bg-[#1f1f1f] px-3 py-2 text-[10px] text-[var(--text-soft)]">
                Active  -  Scheduled  -  Drafts  -  Sent (7d)
              </div>
              <div className="grid grid-cols-2 gap-2 text-xs text-[var(--text-muted)]">
                <div className="rounded-xl bg-[#1f1f1f] px-3 py-2">
                  Points Redeemed (MTD) 860k
                </div>
                <div className="rounded-xl bg-[#1f1f1f] px-3 py-2">
                  Driver Credits (MTD) $4,780
                </div>
                <div className="rounded-xl bg-[#1f1f1f] px-3 py-2">
                  Active Perks 12
                </div>
                <div className="rounded-xl bg-[#1f1f1f] px-3 py-2">
                  Total Sponsors 6
                </div>
              </div>
            </div>

            <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
              <p className="text-xs uppercase tracking-[0.2em] text-[var(--text-soft)]">
                Flow Builder
              </p>
              <div className="mt-4 grid gap-3 text-xs text-[var(--text-muted)]">
                <div className="rounded-xl bg-[#1f1f1f] px-4 py-3">
                  Trigger: On app open (Fri-Sun)
                </div>
                <div className="rounded-xl bg-[#1f1f1f] px-4 py-3">
                  Audience: New riders (30d) in Nassau
                </div>
                <div className="rounded-xl bg-[#1f1f1f] px-4 py-3">
                  Message: In-app 5% off - Start now
                </div>
                <div className="rounded-xl bg-[#1f1f1f] px-4 py-3">
                  A/B Split: A 70% / B 30%  -  Simulate Cost
                </div>
                <div className="rounded-xl bg-[#1f1f1f] px-4 py-3">
                  Wait 5  -  Event name: ride_completed
                </div>
                <div className="rounded-xl bg-[#1f1f1f] px-4 py-3">
                  End branch (track conversion)  -  Send push reminder
                </div>
                <div className="rounded-xl bg-[#1f1f1f] px-4 py-3">
                  Estimated monthly cost: $12,500  -  50k sends
                </div>
                <div className="rounded-xl bg-[#1f1f1f] px-4 py-3">
                  Quiet hours: 22:00 - 08:00  -  Frequency cap per user 2/day
                </div>
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
                {sponsors.map((sponsor) => (
                  <div
                    key={sponsor.name}
                    className="flex items-center justify-between rounded-xl bg-[#1f1f1f] px-3 py-2"
                  >
                    <div>
                      <p className="text-white">{sponsor.name}</p>
                      <p className="text-[10px] text-[var(--text-soft)]">
                        {sponsor.perk}
                      </p>
                    </div>
                    <span className="text-[10px]">{sponsor.tier}</span>
                  </div>
                ))}
              </div>
              <div className="rounded-xl bg-[#1f1f1f] px-3 py-2 text-[10px] text-[var(--text-soft)]">
                Rider earn rate (pts per USD) 200  -  Driver earn rate (pts per USD
                GMV) 50
              </div>
              <div className="rounded-xl bg-[#1f1f1f] px-3 py-2 text-[10px] text-[var(--text-soft)]">
                Redemption Milestones: 50,000 to $5  -  100,000 to $10  -  250,000 to
                $25
              </div>
              <div className="rounded-xl bg-[#1f1f1f] px-3 py-2 text-[10px] text-[var(--text-soft)]">
                Monthly caps: Bronze 10 USD  -  Silver 20 USD  -  Gold 30 USD
              </div>
              <div className="rounded-xl bg-[#1f1f1f] px-3 py-2 text-[10px] text-[var(--text-soft)]">
                Channels: In-app  -  Push  -  Email  -  SMS  -  CTA link
                ride://promo/rubis-weekend
              </div>
              <div className="flex flex-wrap gap-2 text-[10px] text-[var(--text-soft)]">
                <Link
                  href={internalActionRoutes.addPerk}
                  className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
                >
                  + Add Perk
                </Link>
                <Link
                  href={internalActionRoutes.removeSponsor}
                  className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
                >
                  Remove Sponsor
                </Link>
                <Link
                  href={internalActionRoutes.saveAllChanges}
                  className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
                >
                  Save All Changes
                </Link>
              </div>
            </div>
          </div>
        </section>
      </main>
    </div>
  );
}
