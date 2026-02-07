type PageContentProps = {
  title: string;
  description?: string;
  highlights?: string[];
};

export function PageContent({
  title,
  description,
  highlights = [],
}: PageContentProps) {
  return (
    <section className="space-y-6">
      <div className="rounded-2xl border border-white/10 bg-white/5 p-6">
        <p className="text-xs uppercase tracking-[0.25em] text-slate-400">
          {title}
        </p>
        <h2 className="mt-3 text-2xl font-semibold text-white">
          Em migração do Flutter
        </h2>
        <p className="mt-2 text-sm text-slate-400">
          {description ??
            "Esta tela está sendo reconstruída em React/Next.js. Vamos portar dados, filtros e ações em seguida."}
        </p>
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        {highlights.map((item) => (
          <div
            key={item}
            className="rounded-2xl border border-white/10 bg-slate-900/60 p-4 text-sm text-slate-300"
          >
            {item}
          </div>
        ))}
      </div>
    </section>
  );
}
