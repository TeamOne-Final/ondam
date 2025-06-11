import base64
from fastapi import APIRouter, File, Form, UploadFile
import pymysql


router = APIRouter()
ip = "192.168.50.8"

def connect():
        return pymysql.connect(
                host=ip,
                user="root",
                password="qwer1234", 
                db="ondam",           
                charset="utf8",
        )

# 총 매장 수
@router.get("/select/store_count")
async def store_count():
        conn=connect()
        curs=conn.cursor()
        sql = "SELECT COUNT(*) FROM manager WHERE managerId != 'M000'"
        curs.execute(sql)
        row = curs.fetchone()
        conn.close()
        return {'result':row[0]}

# 당일 총 매출
@router.get("/select/today_sales")
async def today_sales():
        conn=connect()
        curs=conn.cursor()
        sql = "SELECT SUM(quantity * menuPrice) FROM purchase, product WHERE menuCode = product_MenuCode AND DATE(tranDate) = CURDATE()"
        curs.execute(sql)
        row = curs.fetchone()
        conn.close()
        return{'result':row[0]}

# 당일 주문 건수
@router.get("/select/today_order_count")
async def today_order_count():
        conn=connect()
        curs=conn.cursor()
        sql = "SELECT COUNT(purchaseNum) FROM purchase WHERE DATE(tranDate) = CURDATE()"
        curs.execute(sql)
        row = curs.fetchone()
        conn.close()
        return{'result':row[0]}

# 가맹점 목록 for 스프레드 시트(테이블에 매니저 명 추가되면 수정필요)
@router.get("/select/store_list")
async def store_list():
        conn=connect()
        curs=conn.cursor()
        sql = "SELECT companyCode, SUBSTRING(location, 1, 2) FROM manager WHERE managerId != 'M000'"
        curs.execute(sql)
        rows = curs.fetchall()
        conn.close()
        result = [{'companyCode':row[0], 'location':row[1]}for row in rows]
        return{'results':result}

@router.get("/select/item_list")
async def item_list():
        conn=connect()
        curs=conn.cursor()
        sql = "SELECT * FROM product ORDER BY menuCode"
        curs.execute(sql)
        rows = curs.fetchall()
        conn.close()
        result = [
        {
        'menuCode': row[0],
        'menuName': row[1],
        'menuPrice': row[2],
        'menuImage': base64.b64encode(row[3]).decode('utf-8') if row[3] else None,
        'description': row[4]
        }
        for row in rows
        ]
        return{'results':result}

@router.post("/insert/item")
async def insert_item(menuCode: str=Form(...), menuName: str=Form(...), menuPrice: str=Form(...), file: UploadFile = File(...), description: str=Form(...)):
        menuImage = await file.read()
        conn=connect()
        curs=conn.cursor()
        sql = """
        INSERT INTO product (menuCode, menuName, menuPrice, menuImage, description)
        VALUES (%s, %s, %s, %s, %s)
        """
        curs.execute(sql, (menuCode, menuName, menuPrice, menuImage, description))
        conn.commit()
        conn.close()
        return{'result':'OK'}

@router.post("/update/item")
async def update(menuCode: str=Form(...), menuName: str=Form(...), menuPrice: str=Form(...), description: str=Form(...)):
        try:
                conn=connect()
                curs=conn.cursor()
                sql = "UPDATE product SET menuName=%s, menuPrice=%s, description=%s WHERE menuCode=%s"
                curs.execute(sql, (menuName, menuPrice, description, menuCode))
                conn.commit()
                conn.close()
                return {'result' : 'OK'}
        except Exception as e:
                print("Error :", e)
                return {'result' : 'Error'}

@router.post("/update/item_with_image") #(...)은 required
async def update_with_image(menuCode: str=Form(...), menuName: str=Form(...), menuPrice: str=Form(...), description: str=Form(...), file: UploadFile = File(...)):
        try:
                menuImage = await file.read()
                conn = connect()
                curs = conn.cursor()
                sql = "UPDATE product SET menuName=%s, menuPrice=%s, description=%s, menuImage=%s WHERE menuCode=%s"
                curs.execute(sql, (menuName, menuPrice, description, menuImage, menuCode))
                conn.commit()
                conn.close()
                return {'result':'OK'}
        except Exception as e:
                print("Error:", e)
                return{"result":"Error"}