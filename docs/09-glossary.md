# 09 — Glossary

| Istilah | Arti di konteks Kognita |
| ------- | ----------------------- |
| **Tenant** | Organisasi pelanggan SaaS; unit isolasi data |
| **Multi-tenant** | Satu aplikasi melayani banyak tenant dengan data terpisah secara logis |
| **RAG** | Retrieval-Augmented Generation — LLM menjawab dengan konteks dokumen yang di-retrieve |
| **Embedding** | Representasi vektor numerik dari teks untuk similarity search |
| **Chunk** | Potongan teks dokumen yang di-embed dan di-index |
| **Hybrid search** | Gabungan keyword (BM25) + semantic (vector) |
| **pgvector** | Ekstensi PostgreSQL untuk menyimpan & mencari vektor |
| **Ingestion** | Pipeline proses dokumen: extract → chunk → embed → index |
| **SSE** | Server-Sent Events — streaming token jawaban ke klien |
| **Agent** | LLM yang bisa memilih & memanggil tools untuk bertindak |
| **Tool calling** | Mekanisme LLM meminta eksekusi fungsi (mis. buat tiket) |
| **Guardrail** | Aturan pengaman input/output/tool agar AI tetap aman & relevan |
| **Eval** | Evaluasi otomatis/manual kualitas jawaban AI |
| **Hallucination** | LLM mengarang fakta yang tidak ada di konteks |
| **Sitasi / citation** | Referensi ke dokumen/chunk sumber jawaban |
| **DLQ** | Dead Letter Queue — antrean pesan gagal berulang |
| **Idempotency** | Memproses event yang sama berulang tidak mengubah hasil akhir secara salah |
| **JWT** | JSON Web Token untuk autentikasi stateless |
| **RBAC** | Role-Based Access Control |
| **IDOR** | Insecure Direct Object Reference — akses objek lewat ID tanpa cek hak |
| **TTFT** | Time To First Token — latency sampai token pertama streaming |
| **ADR** | Architecture Decision Record — catatan keputusan arsitektur |
| **SLO / SLI** | Service Level Objective / Indicator — target & ukuran keandalan |
| **MinIO** | Object storage kompatibel S3 untuk file dokumen |
| **Ollama** | Runtime model LLM/embedding lokal |
| **Spring AI** | Abstraksi Spring untuk chat, embedding, tools |
| **Modular monolith** | Satu deployable, terorganisir per modul domain |
| **Flyway** | Tool migrasi skema database berversi |

---

## Referensi Silang

- Produk & scope → [01-product-overview](./01-product-overview.md)
- Proses bisnis → [03-business-process](./03-business-process.md)
- Tabel & ERD → [04-data-model](./04-data-model.md)
- Rencana fase belajar → [kognita-plan](./kognita-plan.md)
