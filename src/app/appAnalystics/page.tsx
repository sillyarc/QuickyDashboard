import { PageContent } from "@/components/PageContent";

export default function AppAnalyticsPage() {
  return (
    <PageContent
      title="App Analytics"
      description="Indicadores de uso, receita e performance."
      highlights={[
        "Crescimento mensal e recorrência.",
        "Aquisição por canal e plataforma.",
        "Alertas de queda de performance.",
      ]}
    />
  );
}
