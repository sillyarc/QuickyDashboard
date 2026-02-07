"use client";

import { usePathname } from "next/navigation";
import { quickyDashboardRoutes } from "@/lib/routes";

export function Topbar() {
  const pathname = usePathname();
  const current =
    quickyDashboardRoutes.find((route) => route.path === pathname) ??
    quickyDashboardRoutes[0];

  return (
    <header className="flex flex-col gap-2 border-b border-white/10 pb-4">
      <p className="text-xs uppercase tracking-[0.2em] text-slate-400">
        Quicky Dashboard
      </p>
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <h1 className="text-2xl font-semibold text-white">
            {current?.label ?? "Dashboard"}
          </h1>
          {current?.description ? (
            <p className="mt-1 text-sm text-slate-400">
              {current.description}
            </p>
          ) : null}
        </div>
        <div className="flex items-center gap-2">
          <button className="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs text-slate-200 transition hover:bg-white/10">
            Exportar
          </button>
          <button className="rounded-full bg-gradient-to-r from-amber-500 to-rose-500 px-3 py-1 text-xs font-semibold text-slate-950">
            Criar
          </button>
        </div>
      </div>
    </header>
  );
}

