from fastapi import FastAPI
from hakhyun import router as hakhyun_router
from inhwan import router as inhwan_router
from giho import router as giho_router
from taemin import router as taemin_router
from sangbeom import router as sangbeom_router

ip = "192.168.50.8"

app = FastAPI() 
app.include_router(hakhyun_router,prefix="/hakhyun")
app.include_router(inhwan_router,prefix="/inhwan")
app.include_router(giho_router,prefix="/giho")
app.include_router(taemin_router,prefix="/taemin")
app.include_router(sangbeom_router,prefix="/sangbeom")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app,host='127.0.0.1',port=8000)
