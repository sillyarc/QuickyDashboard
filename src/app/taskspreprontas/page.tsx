import { PageContent } from "@/components/PageContent";

export default function TarefasPreProntasPage() {
  return (
    <PageContent
      title="Tarefas Pré-Prontas"
      description="Catálogo de tarefas padrão."
      highlights={[
        "Templates configuráveis por categoria.",
        "Status e disponibilidade em produção.",
        "Ações rápidas para duplicar ou editar.",
      ]}
    />
  );
}
