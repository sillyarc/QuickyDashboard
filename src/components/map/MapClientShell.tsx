"use client";

import dynamic from "next/dynamic";

const FullScreenWorldMap = dynamic(() => import("./FullScreenWorldMap"), {
  ssr: false,
  loading: () => (
    <div className="grid h-screen w-screen place-items-center bg-[#050505] text-sm text-white/80">
      Loading map...
    </div>
  ),
});

export default function MapClientShell() {
  return <FullScreenWorldMap />;
}
