"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { quickyDashboardRoutes } from "@/lib/routes";

export function Sidebar() {
  const pathname = usePathname();

  return (
    <aside className="flex h-full w-full flex-col border-r border-white/10 bg-slate-950/70 px-4 py-6 text-slate-100">
      <div className="mb-6 flex items-center gap-3">
        <div className="h-10 w-10 rounded-xl bg-gradient-to-br from-amber-500 to-rose-500" />
        <div>
          <p className="text-sm uppercase tracking-[0.2em] text-slate-400">
            Quicky
          </p>
          <p className="text-lg font-semibold">Dashboard Admin</p>
        </div>
      </div>

      <nav className="flex-1 space-y-1">
        {quickyDashboardRoutes.map((route) => {
          const active =
            pathname === route.path || pathname?.startsWith(`${route.path}/`);
          return (
            <Link
              key={route.key}
              href={route.path}
              className={[
                "flex items-start justify-between rounded-xl px-3 py-3 text-sm transition",
                active
                  ? "bg-white/10 text-white shadow-[0_8px_20px_-12px_rgba(255,255,255,0.4)]"
                  : "text-slate-300 hover:bg-white/5 hover:text-white",
              ].join(" ")}
            >
              <span className="font-medium">{route.label}</span>
              <span className="text-xs text-slate-500">→</span>
            </Link>
          );
        })}
      </nav>

      <div className="mt-6 rounded-2xl border border-white/10 bg-white/5 p-4 text-xs text-slate-300">
        <p className="font-semibold text-slate-200">Migrado de Flutter</p>
        <p className="mt-2 text-slate-400">
          Telas em progresso. Vamos portar dados e interações na sequência.
        </p>
      </div>
    </aside>
  );
}

