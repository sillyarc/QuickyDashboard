import { PageContent } from "@/components/PageContent";

export default function EditTaskPage() {
  return (
    <PageContent
      title="Editar Tarefa"
      description="Atualização de tarefas pré-prontas ou ativas."
      highlights={[
        "Detalhes, status e responsáveis.",
        "Controle de prioridades.",
        "Histórico de alterações.",
      ]}
    />
  );
}
