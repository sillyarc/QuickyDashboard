"use client";

import dynamic from "next/dynamic";

const FullScreenWorldMap = dynamic(() => import("./FullScreenWorldMap"), {
  ssr: false,
  loading: () => (
    <div className="grid h-screen w-full place-items-center bg-[radial-gradient(circle_at_top,_rgba(240,140,0,0.18),_transparent_50%),linear-gradient(180deg,_#151515_0%,_#0c0c0c_100%)] text-sm text-white/80">
      Loading map...
    </div>
  ),
});

export default function MapClientShell() {
  return <FullScreenWorldMap />;
}
