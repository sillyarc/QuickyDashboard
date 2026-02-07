import { PageContent } from "@/components/PageContent";

export default function AllUserPage() {
  return (
    <PageContent
      title="Usuários"
      description="Gestão de perfis, permissões e status."
      highlights={[
        "Lista de usuários e filtros avançados.",
        "Perfil detalhado e histórico de ações.",
        "Segmentação por plataforma e tipo.",
      ]}
    />
  );
}
