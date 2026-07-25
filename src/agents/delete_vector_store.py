"""Tear down the Contoso Pizza vector store and its uploaded files.

Deleting the vector store alone leaves the underlying File objects behind
(they live in a separate Files store and keep accruing storage). This
script removes both.
"""

import os
from dotenv import load_dotenv
from azure.ai.projects import AIProjectClient
from azure.identity import DefaultAzureCredential

load_dotenv()

VECTOR_STORE_NAME = os.getenv("VECTOR_STORE_NAME", "ContosoPizzaStores")


project_client = AIProjectClient(
    endpoint=os.environ["PROJECT_ENDPOINT"],
    credential=DefaultAzureCredential(),
)
openai_client = project_client.get_openai_client()

vector_store = next(
    (vs for vs in openai_client.vector_stores.list() if vs.name == VECTOR_STORE_NAME),
    None,
)
if not vector_store:
    print(f"No vector store named {VECTOR_STORE_NAME!r} found. Nothing to delete.")
    raise SystemExit(0)

file_ids = [
    f.id
    for f in openai_client.vector_stores.files.list(vector_store_id=vector_store.id)
]
print(f"Found vector store {vector_store.id} with {len(file_ids)} file(s).")

confirm = input(f"Delete vector store {vector_store.name!r} and its files? [y/N]: ")
if confirm.strip().lower() != "y":
    print("Aborted.")
    raise SystemExit(0)

for file_id in file_ids:
    try:
        openai_client.files.delete(file_id)
        print(f"Deleted file {file_id}")
    except Exception as err:
        print(f"Could not delete file {file_id}: {err}")

openai_client.vector_stores.delete(vector_store.id)
print(f"Deleted vector store {vector_store.id}")
print("Remove VECTOR_STORE_ID from your .env.")
