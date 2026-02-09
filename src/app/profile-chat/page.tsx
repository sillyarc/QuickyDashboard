import ProfileChatClient from "@/components/profile/ProfileChatClient";

type SearchParams = Record<string, string | string[] | undefined>;

const normalizeParam = (value?: string | string[]) =>
  Array.isArray(value) ? value[0] : value;

export default function ProfileChatPage({
  searchParams,
}: {
  searchParams?: SearchParams;
}) {
  return (
    <ProfileChatClient
      initialName={normalizeParam(searchParams?.name)}
      initialRole={normalizeParam(searchParams?.role)}
      userId={normalizeParam(searchParams?.userId)}
      uid={normalizeParam(searchParams?.uid)}
      phone={normalizeParam(searchParams?.phone)}
    />
  );
}
