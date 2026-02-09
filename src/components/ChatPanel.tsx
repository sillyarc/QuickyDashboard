"use client";

import { useMemo, useState } from "react";

type Message = {
  id: string;
  from: "me" | "them";
  text: string;
  time?: string;
};

type ChatPanelProps = {
  contactName: string;
  initialMessages?: Message[];
};

export default function ChatPanel({
  contactName,
  initialMessages = [],
}: ChatPanelProps) {
  const [messages, setMessages] = useState<Message[]>(initialMessages);
  const [draft, setDraft] = useState("");

  const hasMessages = messages.length > 0;
  const placeholderMessages = useMemo<Message[]>(
    () => [
      {
        id: "system-1",
        from: "them",
        text: `Oi! Estou aqui para ajudar. Pode falar comigo, ${contactName}.`,
        time: "Agora",
      },
    ],
    [contactName]
  );

  const visibleMessages = hasMessages ? messages : placeholderMessages;

  const handleSend = () => {
    const trimmed = draft.trim();
    if (!trimmed) return;
    setMessages((prev) => [
      ...prev,
      {
        id: `${Date.now()}-${Math.random().toString(36).slice(2)}`,
        from: "me",
        text: trimmed,
        time: "Agora",
      },
    ]);
    setDraft("");
  };

  return (
    <div className="rounded-2xl border border-white/10 bg-[#2a2a2a] p-4 shadow-[0_16px_40px_-24px_rgba(0,0,0,0.8)]">
      <div className="flex items-center justify-between gap-4 border-b border-white/10 pb-3">
        <div>
          <p className="text-xs uppercase tracking-[0.3em] text-[var(--text-soft)]">
            Chat direto
          </p>
          <p className="text-lg font-semibold text-white">{contactName}</p>
        </div>
        <span className="rounded-full bg-[#1f1f1f] px-3 py-1 text-[10px] text-[var(--text-muted)]">
          Online
        </span>
      </div>

      <div className="mt-4 flex max-h-[420px] flex-col gap-3 overflow-y-auto pr-2 text-xs text-[var(--text-muted)]">
        {visibleMessages.map((message) => (
          <div
            key={message.id}
            className={`flex ${message.from === "me" ? "justify-end" : "justify-start"}`}
          >
            <div
              className={`max-w-[75%] rounded-2xl px-3 py-2 ${
                message.from === "me"
                  ? "bg-[#fbb125] text-black"
                  : "bg-[#1f1f1f] text-[var(--text-soft)]"
              }`}
            >
              <p>{message.text}</p>
              {message.time ? (
                <p
                  className={`mt-2 text-[10px] ${
                    message.from === "me" ? "text-black/70" : "text-white/40"
                  }`}
                >
                  {message.time}
                </p>
              ) : null}
            </div>
          </div>
        ))}
      </div>

      <div className="mt-4 flex items-center gap-2 rounded-full bg-[#1f1f1f] px-3 py-2 text-xs text-[var(--text-soft)]">
        <input
          value={draft}
          onChange={(event) => setDraft(event.target.value)}
          onKeyDown={(event) => {
            if (event.key === "Enter") {
              event.preventDefault();
              handleSend();
            }
          }}
          placeholder={`Escreva para ${contactName}`}
          className="w-full bg-transparent text-xs text-white placeholder:text-[var(--text-muted)] focus:outline-none"
        />
        <button
          type="button"
          onClick={handleSend}
          className="rounded-full bg-[#fbb125] px-3 py-1 text-[10px] font-semibold text-black transition hover:brightness-110"
        >
          Enviar
        </button>
      </div>
    </div>
  );
}
