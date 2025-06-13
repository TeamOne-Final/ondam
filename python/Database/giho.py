from fastapi import APIRouter
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

@router.get("/select/purchase")
async def purchase():
        conn = connect()
        curs = conn.cursor()
        sql = """
            select ph.cartNum, p.menuName, ph.tranDate, ph.userTable_CompanyCode, sum(ph.quantity*p.menuPrice) as cartNum_total_price
            from product as p, purchase as ph
            where p.menuCode = ph.product_MenuCode
            and ph.userTable_CompanyCode = '강남'
            group by ph.cartNum, p.menuName, ph.tranDate,ph.userTable_CompanyCode
            order by ph.tranDate desc;
        """
        curs.execute(sql)
        rows = curs.fetchall()
        conn.close()
        result = [{"cartNum":row[0], "menuName":row[1], "tranDate":row[2], "userTable_CompanyCode":row[3], "cartNum_total_price":row[4]}for row in rows]
        return{"results":result}


