import { PageContent } from "@/components/PageContent";

export default function EventsPage() {
  return (
    <PageContent
      title="Eventos"
      description="Painel de eventos e campanhas."
      highlights={[
        "Agenda de eventos ativos e futuros.",
        "Detalhes de participantes e operações.",
        "Métricas de engajamento.",
      ]}
    />
  );
}
