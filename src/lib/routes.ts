export type NavRoute = {
  key: string;
  path: string;
  label: string;
  description?: string;
};

export const quickyDashboardRoutes: NavRoute[] = [
  {
    key: "quickysolutionsllcdashboard",
    path: "/quickysolutionsllcdashboard",
    label: "Quicky Dashboard",
    description: "Visão geral e KPIs principais.",
  },
  {
    key: "dashboardQuickyTasks",
    path: "/dashboardQuickyTasks",
    label: "Dashboard Tasks",
    description: "Tarefas e métricas operacionais.",
  },
  {
    key: "dashboardQuickyTasksCopyCopy",
    path: "/dashboardQuickyTasksCopyCopy",
    label: "Dashboard Tasks (Alt)",
    description: "Variação do dashboard de tarefas.",
  },
  {
    key: "users",
    path: "/users",
    label: "Usuários",
    description: "Gestão e visualização de usuários.",
  },
  {
    key: "taskspreprontas",
    path: "/taskspreprontas",
    label: "Tarefas Pré-Prontas",
    description: "Configuração de tarefas prontas.",
  },
  {
    key: "createPreTasks",
    path: "/createPreTasks",
    label: "Criar Pré-Tarefas",
    description: "Formulário de criação.",
  },
  {
    key: "createPreTasksCopy",
    path: "/createPreTasksCopy",
    label: "Criar Pré-Tarefas (Alt)",
    description: "Variação do formulário.",
  },
  {
    key: "edittask",
    path: "/edittask",
    label: "Editar Tarefa",
    description: "Edição de tarefas existentes.",
  },
  {
    key: "events",
    path: "/events",
    label: "Eventos",
    description: "Gestão de eventos.",
  },
  {
    key: "appAnalystics",
    path: "/appAnalystics",
    label: "Analytics",
    description: "Indicadores e análises.",
  },
  {
    key: "quickyTestRealTime",
    path: "/quickyTestRealTime",
    label: "Tempo Real",
    description: "Monitoramento em tempo real.",
  },
  {
    key: "map",
    path: "/map",
    label: "Mapa Global",
    description: "Visao global com usuarios, motoristas e alertas.",
  },
];
