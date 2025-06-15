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
        sql = """
        SELECT companyCode, SUBSTRING(location, 1, 2), managerId, COUNT(purchaseNum) FROM manager LEFT JOIN purchase ON userTable_CompanyCode = companyCode AND SUBSTRING(tranDate, 1,10) = CURDATE() WHERE managerId != 'M000' GROUP BY companyCode, SUBSTRING(location, 1, 2), managerId;
        """
        curs.execute(sql)
        rows = curs.fetchall()
        conn.close()
        result = [{'companyCode':row[0], 'location':row[1], 'managerId':row[2], 'purchase':row[3]}for row in rows]
        return{'results':result}

# 가맹점별 손님이 금일 주문한 횟수 (임시)
@router.get("/select/daily_purchase_count")
async def daily_purchase_count():
        conn=connect()
        curs=conn.cursor()
        sql = "SELECT COUNT(purchaseNum) FROM purchase, manager WHERE SUBSTRING(tranDate, 1, 10) = CURDATE() AND userTable_CompanyCode = companyCode"
        curs.execute(sql)
        row = curs.fetchone()
        conn.close()
        return{'results':row[0]}

@router.get("/select/item_list/{category}")
async def item_list(category: str = None):
        conn=connect()
        curs=conn.cursor()
        sql = f"SELECT * FROM product WHERE menuCode like '{category}%' ORDER BY menuCode"
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

# 메뉴 추가
@router.post("/insert/item")
async def insert_item(menuCode: str=Form(...), menuName: str=Form(...), menuPrice: str=Form(...), file: UploadFile = File(...), description: str=Form(...), date: str=Form(...)):
        menuImage = await file.read()
        conn=connect()
        curs=conn.cursor()
        sql = """
        INSERT INTO product (menuCode, menuName, menuPrice, menuImage, description, date)
        VALUES (%s, %s, %s, %s, %s, %s)
        """
        curs.execute(sql, (menuCode, menuName, menuPrice, menuImage, description, date))
        conn.commit()
        conn.close()
        return{'result':'OK'}

# 메뉴 수정 이미지 제외
@router.post("/update/item")
async def update(menuCode: str=Form(...), menuName: str=Form(...), menuPrice: str=Form(...), description: str=Form(...), date: str=Form(...)):
        try:
                conn=connect()
                curs=conn.cursor()
                sql = "UPDATE product SET menuName=%s, menuPrice=%s, description=%s, date=%s WHERE menuCode=%s"
                curs.execute(sql, (menuName, menuPrice, description, date, menuCode))
                conn.commit()
                conn.close()
                return {'result' : 'OK'}
        except Exception as e:
                print("Error :", e)
                return {'result' : 'Error'}

# 메뉴 수정 이미지 포함
@router.post("/update/item_with_image")
async def update_with_image(menuCode: str=Form(...), menuName: str=Form(...), menuPrice: str=Form(...), description: str=Form(...), file: UploadFile = File(...), date: str=Form(...)):
        try:
                menuImage = await file.read()
                conn = connect()
                curs = conn.cursor()
                sql = "UPDATE product SET menuName=%s, menuPrice=%s, description=%s, menuImage=%s, date=%s WHERE menuCode=%s"
                curs.execute(sql, (menuName, menuPrice, description, menuImage, date, menuCode))
                conn.commit()
                conn.close()
                return {'result':'OK'}
        except Exception as e:
                print("Error:", e)
                return{"result":"Error"}
        
# 메뉴 삭제
@router.delete("/delete/item/{code}")
async def delete_item(code: str):
        try:
                conn=connect()
                curs=conn.cursor()
                curs.execute("DELETE FROM product where menuCode = %s", (code,))
                conn.commit()
                conn.close()
                return {'result':'OK'}
        except Exception as e:
                print("Error:", e)
                return {"result":"Error"}
        
# 남녀 카운트 for 성비
@router.get("/select/gender_count")
async def select_gender_count():
        conn=connect()
        curs=conn.cursor()
        sql = "SELECT SUM(femaleNum), SUM(maleNum) FROM purchase WHERE SUBSTRING(tranDate, 1,7) = SUBSTRING(CURDATE(), 1,7)"
        curs.execute(sql)
        row = curs.fetchone()
        conn.close()
        return{'female':row[0]or 0, 'male':row[1]or 0}