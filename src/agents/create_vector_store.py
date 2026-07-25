"""One-time setup: create (or reuse) the vector store and upload documents.

Run this once, copy the printed VECTOR_STORE_ID into your .env, then run
agent_with_rag.py. Re-running is safe: the store is reused by name and
already-indexed files are skipped.
"""

import glob
import os
from dotenv import load_dotenv
from azure.ai.projects import AIProjectClient
from azure.identity import DefaultAzureCredential

load_dotenv()

VECTOR_STORE_NAME = os.getenv("VECTOR_STORE_NAME", "ContosoPizzaStores")
DOCUMENTS_GLOB = "documents/*.md"


project_client = AIProjectClient(
    endpoint=os.environ["PROJECT_ENDPOINT"],
    credential=DefaultAzureCredential(),
)
openai_client = project_client.get_openai_client()

vector_store = next(
    (vs for vs in openai_client.vector_stores.list() if vs.name == VECTOR_STORE_NAME),
    None,
)
if vector_store:
    print(f"Reusing vector store (id: {vector_store.id})")
else:
    vector_store = openai_client.vector_stores.create(name=VECTOR_STORE_NAME)
    print(f"Vector store created (id: {vector_store.id})")

file_id_to_name = {f.id: f.filename for f in openai_client.files.list()}
already_uploaded = {
    file_id_to_name.get(f.id)
    for f in openai_client.vector_stores.files.list(vector_store_id=vector_store.id)
}

for file_path in glob.glob(DOCUMENTS_GLOB):
    filename = os.path.basename(file_path)
    if filename in already_uploaded:
        print(f"Skipping already-indexed file: {filename}")
        continue
    with open(file_path, "rb") as fh:
        uploaded = openai_client.vector_stores.files.upload_and_poll(
            vector_store_id=vector_store.id, file=fh
        )
    print(f"Uploaded {filename} (id: {uploaded.id})")

print()
print(f"Add this to your .env:\n  VECTOR_STORE_ID={vector_store.id}")
