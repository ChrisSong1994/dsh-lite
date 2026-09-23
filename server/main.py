from fastapi import FastAPI
import uvicorn

app = FastAPI(
    title="DSH Lite Server",
    version="0.1.0",
)


@app.get("/healthz", tags=["system"])
async def healthz() -> dict[str, str]:
    return {"status": "ok"}


def main() -> None:

    uvicorn.run(
        "main:app",
        host="127.0.0.1",
        port=3099,
        reload=True,
    )


if __name__ == "__main__":
    main()
