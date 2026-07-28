# 01 — Ringkasan Produk

## 1. Apa itu Kognita?

**Kognita** adalah platform SaaS **multi-tenant** untuk knowledge management dan customer/internal support berbasis AI.

Setiap organisasi (tenant) meng-upload dokumen knowledge-nya. Pengguna kemudian bertanya ke asisten AI yang:

1. **Menjawab berbasis dokumen** — Retrieval-Augmented Generation (RAG).
2. **Bertindak** — agent dengan tool calling (buat tiket, cari data, eskalasi ke manusia).

Dilengkapi panel admin, analitik penggunaan, dan fondasi billing per tenant.

---

## 2. Masalah yang Diselesaikan

| Masalah | Dampak | Solusi Kognita |
| ------- | ------ | -------------- |
| Knowledge tersebar di PDF, wiki, chat | Sulit dicari, jawaban tidak konsisten | Index + hybrid search + RAG |
| Support menjawab pertanyaan berulang | Biaya & waktu tinggi | Asisten AI 24/7 berbasis dokumen resmi |
| Halusinasi LLM tanpa sumber | Risiko informasi salah | Sitasi chunk dokumen + guardrails |
| Escalasi manual lambat | SLA support menurun | Agent buat tiket / eskalasi otomatis |
| Isolasi data antar organisasi | Risiko kebocoran data SaaS | Multi-tenant isolation ketat |

---

## 3. Value Proposition

- **Untuk organisasi:** knowledge base yang bisa ditanya dalam bahasa natural, dengan jejak sumber.
- **Untuk agent support:** mengurangi volume tiket L1; fokus ke kasus kompleks.
- **Untuk admin:** kontrol dokumen, prompt, user, dan metrik penggunaan.
- **Untuk developer/pembelajar:** satu proyek yang mencakup API, DB, messaging, search, AI production, dan arsitektur.

---

## 4. Persona Utama

### 4.1 Org Admin (`ADMIN`)

- Mengelola user dalam organisasi.
- Upload & kelola dokumen knowledge.
- Konfigurasi system prompt asisten.
- Melihat analytics (jumlah chat, dokumen, tiket).

### 4.2 End User / Employee (`USER`)

- Bertanya ke asisten AI.
- Melihat riwayat percakapan.
- Membuat / melihat tiket yang dibuat agent (jika diizinkan).

### 4.3 Support Agent (`SUPPORT`) — Fase 4+

- Menerima eskalasi dari AI.
- Menangani tiket yang dibuat agent.
- Menambahkan / mengoreksi knowledge (opsional).

### 4.4 Platform Operator (internal Kognita) — Fase 5+

- Mengelola tenant di level platform.
- Monitoring infrastruktur, SLO, billing.

---

## 5. Scope Produk

### In Scope (target penuh)

- Multi-tenant auth (registrasi organisasi + user, JWT).
- Upload & CRUD dokumen (file di object storage).
- Chat LLM streaming (SSE).
- Ingestion async: chunk → embed → index.
- RAG + hybrid search + sitasi sumber.
- Agent tools: create ticket, search, escalate.
- Evals, guardrails, observability.
- Evolusi ke microservices + deploy cloud (opsional).

### Out of Scope (sengaja tidak digarap dulu)

- Mobile native app.
- Real-time collaborative editing dokumen.
- Marketplace plugin pihak ketiga.
- Full payment gateway production (cukup fondasi billing/usage metering).
- Multi-language UI yang lengkap (fokus backend & AI dulu).

---

## 6. Asumsi Bisnis

1. Satu user milik **satu tenant** (simplifikasi Fase 1–4).
2. Dokumen yang diupload adalah sumber kebenaran untuk jawaban AI.
3. LLM lokal (Ollama) cukup untuk development; cloud LLM opsional.
4. Isolasi data antar tenant adalah **non-negotiable**.
5. Ingestion dokumen tidak boleh memblokir request upload (async).

---

## 7. Metrik Sukses (Produk)

| Metrik | Target arah |
| ------ | ----------- |
| Akurasi jawaban (eval / human rating) | Meningkat seiring kualitas dokumen & retrieval |
| % pertanyaan terjawab tanpa eskalasi | Naik setelah RAG stabil |
| p95 latency chat | &lt; 3s (target SLO Fase 5) |
| Zero data leak antar tenant | Wajib di semua fase |
| Waktu dari upload → dokumen searchable | Detik–menit, bukan jam |

---

## 8. Peta Fitur vs Fase

| Fitur | F1 | F2 | F3 | F4 | F5 |
| ----- | -- | -- | -- | -- | -- |
| Auth + multi-tenant | ✓ | | | | |
| Upload dokumen | ✓ | | | | |
| Chat streaming | | ✓ | | | |
| Riwayat conversation | | ✓ | | | |
| RAG + ingestion | | | ✓ | | |
| Hybrid search | | | ✓ | | |
| Agent + tiket | | | | ✓ | |
| Evals + observability | | | | ✓ | |
| Microservices + K8s | | | | | ✓ |

Detail pengerjaan: [`kognita-plan.md`](./kognita-plan.md).
