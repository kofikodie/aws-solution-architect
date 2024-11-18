from fastapi import FastAPI
import random

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int):
    qty = random.randint(0, 10)
    return {"item_id": item_id, "qty": qty}
