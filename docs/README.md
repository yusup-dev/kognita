# Dokumentasi Kognita

Dokumentasi lengkap platform **Kognita** — AI Knowledge & Support Platform multi-tenant.

> Rencana pengerjaan bertahap (fase belajar) tetap di [`kognita-plan.md`](./kognita-plan.md).

---

## Daftar Dokumen

| No | Dokumen | Isi |
| -- | ------- | --- |
| 01 | [Ringkasan Produk](./01-product-overview.md) | Visi, value proposition, persona, scope |
| 02 | [Aktor & Use Case](./02-actors-use-cases.md) | Siapa yang memakai sistem dan apa yang mereka lakukan |
| 03 | [Proses Bisnis](./03-business-process.md) | Alur bisnis end-to-end per domain |
| 04 | [Model Data & Relasi Tabel](./04-data-model.md) | ERD, skema tabel, constraint, indeks |
| 05 | [Arsitektur Sistem](./05-architecture.md) | Komponen, integrasi, evolusi monolith → microservices |
| 06 | [Spesifikasi API](./06-api-specification.md) | Endpoint REST, auth, kontrak request/response |
| 07 | [Security & Multi-Tenancy](./07-security-multi-tenant.md) | Isolasi tenant, JWT, otorisasi, OWASP |
| 08 | [Pipeline RAG & AI](./08-rag-ai-pipeline.md) | Ingestion, embedding, retrieval, agent, evals |
| 09 | [Glossary](./09-glossary.md) | Istilah teknis & bisnis |

---

## Cara Membaca

1. Mulai dari **01 → 03** untuk memahami *apa* yang dibangun dan *bagaimana* proses bisnisnya.
2. Lanjut **04** untuk desain database sebelum coding.
3. Pakai **05–08** saat implementasi Fase 1–5.
4. Rujuk **09** bila istilah kurang familiar.

---

## Status Dokumen

| Aspek | Status |
| ----- | ------ |
| Proses bisnis & use case | Desain target (semua fase) |
| Model data | Desain lengkap; implementasi bertahap per fase |
| API | Kontrak desain; belum diimplementasi penuh |
| Kode aplikasi | Skeleton Spring Boot — lihat `kognita-plan.md` untuk fase |

*Dokumen ini adalah sumber kebenaran desain. Jika implementasi berbeda, update dokumen atau tulis ADR di `docs/adr/`.*
