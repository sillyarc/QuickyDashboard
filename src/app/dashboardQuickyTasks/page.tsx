import { PageContent } from "@/components/PageContent";

export default function DashboardQuickyTasksPage() {
  return (
    <PageContent
      title="Dashboard Quicky Tasks"
      description="Operação diária de tarefas e performance."
      highlights={[
        "Fila de tarefas, status e responsáveis.",
        "KPIs de performance e tempo médio.",
        "Ações rápidas para ajustes operacionais.",
      ]}
    />
  );
}
