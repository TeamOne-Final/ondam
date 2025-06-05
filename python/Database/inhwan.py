from fastapi import APIRouter
import pymysql


router = APIRouter()
ip = "192.168.50.8"

def connect():
        conn = pymysql.connect(
        host=ip,
        user="root",
        password="qwer1234", 
        db="ondam",           
        charset="utf8",
        )
        return conn

@router.get("/selectUser")
async def selectUser(managerId : str, managerPassword : str):
        conn = connect()
        curs = conn.cursor()
        curs.execute("SELECT count(*), companyCode From manager WHERE managerId =%s and managerPassword =%s", (managerId, managerPassword))
        rows = curs.fetchall()
        conn.close()
        result = [{"count":row[0], "companyCode":row[1]}for row in rows]
        return {'results' : result}