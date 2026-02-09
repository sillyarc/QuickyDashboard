import Link from "next/link";

const disputeStats = [
  { label: "Open Disputes", value: "42", delta: "+ 6%" },
  { label: "Resolved This Month", value: "128", delta: "+ 3%" },
  { label: "Avg Resolution Time", value: "2d 14h", delta: "- 8%" },
  { label: "Refunds Issued", value: "$3,200", delta: "+ 2%" },
];

const disputeTable = [
  {
    id: "D-10922",
    date: "Sep 06",
    rider: "Enzo G.",
    driver: "Sam M.",
    category: "Payment",
    amount: "$12.40",
    status: "Open",
  },
  {
    id: "D-10911",
    date: "Sep 05",
    rider: "Ana J.",
    driver: "Leo P.",
    category: "Behavior",
    amount: "-",
    status: "Escalated",
  },
  {
    id: "D-10888",
    date: "Sep 04",
    rider: "Will T.",
    driver: "Kai R.",
    category: "Ride Quality",
    amount: "-",
    status: "Under Review",
  },
  {
    id: "D-10864",
    date: "Sep 04",
    rider: "Mia C.",
    driver: "Jin L.",
    category: "Payment",
    amount: "$8.60",
    status: "Resolved",
  },
  {
    id: "D-10850",
    date: "Sep 03",
    rider: "Jake L.",
    driver: "Nora S.",
    category: "Behavior",
    amount: "-",
    status: "Open",
  },
  {
    id: "D-10833",
    date: "Sep 03",
    rider: "Lara K.",
    driver: "Derek F.",
    category: "Payment",
    amount: "$18.40",
    status: "Resolved",
  },
  {
    id: "D-10822",
    date: "Sep 02",
    rider: "Rin P.",
    driver: "Omar A.",
    category: "Ride Quality",
    amount: "-",
    status: "Escalated",
  },
];

const expenses = [
  {
    name: "Payroll - Employees",
    category: "Payroll",
    amount: "$48,720",
    frequency: "Monthly",
    status: "Active",
  },
  {
    name: "Driver Payouts",
    category: "Operational",
    amount: "$18,990",
    frequency: "Daily",
    status: "Auto",
  },
  {
    name: "Payroll - Ops Team",
    category: "Payroll",
    amount: "$12,000",
    frequency: "Monthly",
    status: "Active",
  },
  {
    name: "Payroll - CS",
    category: "Payroll",
    amount: "$6,400",
    frequency: "Monthly",
    status: "Active",
  },
  {
    name: "AWS and Infra",
    category: "Software",
    amount: "$1,900",
    frequency: "Monthly",
    status: "Active",
  },
  {
    name: "Office Internet",
    category: "Utilities",
    amount: "$180",
    frequency: "Monthly",
    status: "Active",
  },
];

const recurringExpenses = [
  {
    name: "Airport signage",
    category: "Marketing",
    amount: "$420",
    date: "Sep 4",
    type: "One-time",
    status: "Paid",
  },
  {
    name: "Car repair - D119",
    category: "Operational",
    amount: "$310",
    date: "Sep 5",
    type: "Breakdown",
    status: "Paid",
  },
  {
    name: "Legal filing",
    category: "Legal",
    amount: "$600",
    date: "Sep 2",
    type: "Compliance doc",
    status: "Pending",
  },
  {
    name: "Replacement phones",
    category: "Hardware",
    amount: "$1,220",
    date: "Sep 1",
    type: "CS devices",
    status: "Paid",
  },
];

const disputeTimeline = [
  "Sep 06 14:12 - Dispute opened by rider",
  "Sep 06 14:15 - Auto-collected GPS and fare log",
  "Sep 06 14:45 - Support assigned: Ana J.",
  "Rider message: 'Driver took longer route and AC was off.'",
  "System: GPS path available; fare calculation logged.",
  "Sep 06 15:30 - Driver responded with route screenshot",
];

const internalActionRoutes = {
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
};

export default function DisputesExpensePage() {
  return (
    <main className="min-h-screen px-6 py-8 lg:px-10">
      <section className="space-y-6">
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          {disputeStats.map((stat) => (
            <div
              key={stat.label}
              className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4"
            >
              <p className="text-xs uppercase tracking-[0.2em] text-[var(--text-soft)]">
                {stat.label}
              </p>
              <p className="mt-2 text-2xl font-semibold text-white">
                {stat.value}
              </p>
              <span className="mt-2 inline-flex rounded-full bg-[#1f1f1f] px-3 py-1 text-[10px] text-[#98f0b2]">
                {stat.delta}
              </span>
            </div>
          ))}
        </div>

        <div className="grid gap-6 lg:grid-cols-[1.3fr_0.9fr]">
          <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
            <div className="flex items-center justify-between">
              <p className="text-sm font-semibold text-white">
                Selected Dispute: D-10922
              </p>
              <span className="text-xs text-[var(--text-muted)]">
                Filters: Open | Under Review | Resolved | Escalated
              </span>
            </div>
            <div className="mt-4 overflow-x-auto">
              <table className="min-w-full text-left text-xs text-[var(--text-muted)]">
                <thead>
                  <tr className="border-b border-white/10 text-[10px] uppercase tracking-[0.2em] text-[var(--text-soft)]">
                    <th className="py-2">ID</th>
                    <th className="py-2">Date</th>
                    <th className="py-2">Rider</th>
                    <th className="py-2">Driver</th>
                    <th className="py-2">Category</th>
                    <th className="py-2">Amount</th>
                    <th className="py-2">Status</th>
                    <th className="py-2">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {disputeTable.map((row) => (
                    <tr key={row.id} className="border-b border-white/5">
                      <td className="py-2 text-white">{row.id}</td>
                      <td className="py-2">{row.date}</td>
                      <td className="py-2">{row.rider}</td>
                      <td className="py-2">{row.driver}</td>
                      <td className="py-2">{row.category}</td>
                      <td className="py-2">{row.amount}</td>
                      <td className="py-2">
                        <span className="rounded-full bg-[#1f1f1f] px-2 py-1 text-[10px]">
                          {row.status}
                        </span>
                      </td>
                      <td className="py-2 text-[10px] text-[var(--text-soft)]">
                        <Link
                          href={`/edittask?dispute=${row.id}`}
                          className="rounded-full bg-[#1f1f1f] px-2 py-1 transition hover:bg-[#2b2b2b] hover:text-white"
                        >
                          View
                        </Link>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          <div className="space-y-4">
            <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
              <p className="text-sm font-semibold text-white">Dispute Details</p>
              <div className="mt-3 space-y-2 text-xs text-[var(--text-muted)]">
                <p>Rider: Enzo G. (4.9)  -  Driver: Sam M. (4.7)</p>
                <p>
                  Ride: Airport to Downtown  -  Category: Payment  -  Amount:
                  $12.40
                </p>
                <p>Dispute Reason: Driver took longer route and AC was off.</p>
              </div>
              <div className="mt-4 space-y-2 rounded-xl bg-[#1f1f1f] p-3 text-[10px] text-[var(--text-soft)]">
                {disputeTimeline.map((item) => (
                  <p key={item}>{item}</p>
                ))}
              </div>
              <div className="mt-4 flex flex-wrap gap-2">
                <Link
                  href={internalActionRoutes.resolveDispute}
                  className="rounded-xl bg-[#16b047] px-3 py-2 text-xs text-black transition hover:brightness-110"
                >
                  Resolve (no refund)
                </Link>
                <Link
                  href={internalActionRoutes.refundRider}
                  className="rounded-xl bg-[#fbb125] px-3 py-2 text-xs text-black transition hover:brightness-110"
                >
                  Refund rider
                </Link>
                <Link
                  href={internalActionRoutes.escalateDispute}
                  className="rounded-xl bg-[#ff3535] px-3 py-2 text-xs text-white transition hover:brightness-110"
                >
                  Escalate
                </Link>
              </div>
            </div>

            <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
              <p className="text-sm font-semibold text-white">Employees</p>
              <div className="mt-3 space-y-2 text-xs text-[var(--text-muted)]">
                <div className="flex items-center justify-between rounded-lg bg-[#1f1f1f] px-3 py-2">
                  <span>Ana Jones  -  Customer Support  -  CX</span>
                  <span>$1,600  -  Active</span>
                </div>
                <div className="flex items-center justify-between rounded-lg bg-[#1f1f1f] px-3 py-2">
                  <span>Jake Lee  -  Operations Lead  -  Ops</span>
                  <span>$2,800  -  Active</span>
                </div>
                <div className="flex items-center justify-between rounded-lg bg-[#1f1f1f] px-3 py-2">
                  <span>Mia Cruz  -  Driver Coach  -  Ops</span>
                  <span>$2,200  -  Active</span>
                </div>
                <div className="flex items-center justify-between rounded-lg bg-[#1f1f1f] px-3 py-2">
                  <span>Sam Roy  -  Compliance  -  Legal</span>
                  <span>$2,400  -  Active</span>
                </div>
              </div>
              <div className="mt-3 flex flex-wrap gap-2 text-[10px] text-[var(--text-soft)]">
                <Link
                  href={internalActionRoutes.addEmployee}
                  className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
                >
                  Add Employee
                </Link>
                <Link
                  href={internalActionRoutes.payrollEmployees}
                  className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
                >
                  Payroll - Employees
                </Link>
                <Link
                  href={internalActionRoutes.newExpense}
                  className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
                >
                  New Expense
                </Link>
              </div>
            </div>
          </div>
        </div>

        <div className="grid gap-6 lg:grid-cols-[1.1fr_0.9fr]">
          <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
            <p className="text-sm font-semibold text-white">Total Expenses (MTD)</p>
            <div className="mt-4 grid gap-3 text-xs text-[var(--text-muted)]">
              {expenses.map((item) => (
                <div
                  key={item.name}
                  className="grid gap-2 rounded-xl bg-[#1f1f1f] px-4 py-3 md:grid-cols-[1.4fr_1fr_1fr_1fr_1fr]"
                >
                  <span className="text-white">{item.name}</span>
                  <span>{item.category}</span>
                  <span>{item.amount}</span>
                  <span>{item.frequency}</span>
                  <span>{item.status}</span>
                </div>
              ))}
            </div>
            <p className="mt-4 text-[10px] text-[var(--text-soft)]">
              Tip: Driver payouts are added automatically each day.
            </p>
          </div>

          <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4">
            <p className="text-sm font-semibold text-white">Recent Expenses</p>
            <div className="mt-4 space-y-3 text-xs text-[var(--text-muted)]">
              {recurringExpenses.map((item) => (
                <div
                  key={item.name}
                  className="flex flex-wrap items-center justify-between gap-2 rounded-xl bg-[#1f1f1f] px-4 py-3"
                >
                  <div>
                    <p className="text-white">{item.name}</p>
                    <p className="text-[10px] text-[var(--text-soft)]">
                      {item.category}  -  {item.type}
                    </p>
                  </div>
                  <div className="text-right text-[10px] text-[var(--text-soft)]">
                    <p>{item.amount}</p>
                    <p>{item.date}</p>
                    <p>{item.status}</p>
                  </div>
                </div>
              ))}
            </div>
            <div className="mt-4 flex flex-wrap gap-2 text-[10px] text-[var(--text-soft)]">
              <Link
                href={internalActionRoutes.addExpense}
                className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
              >
                Add Expense
              </Link>
              <Link
                href={internalActionRoutes.setRecurring}
                className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
              >
                Set Recurring
              </Link>
              <Link
                href={internalActionRoutes.importCsv}
                className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
              >
                Import CSV
              </Link>
              <Link
                href={internalActionRoutes.exportCsv}
                className="rounded-full bg-[#1f1f1f] px-3 py-1 transition hover:bg-[#2b2b2b]"
              >
                Export CSV
              </Link>
            </div>
          </div>
        </div>
      </section>
    </main>
  );
}
