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
async def purchase(storeCode : str = None, date : str = None):
        conn = connect()
        curs = conn.cursor()
        sql = f"""
        SELECT
            ph.cartNum,
            GROUP_CONCAT(
                CONCAT(p.menuName, ' x', ph.quantity, '개')
                ORDER BY p.menuName
                SEPARATOR '\n'
            ) AS receiptLine,
                GROUP_CONCAT(
                CONCAT(ph.quantity*p.menuPrice, '원')
                ORDER BY p.menuName
                SEPARATOR '\n'
            ) AS sales_menus,
            ph.tranDate,
            ph.userTable_CompanyCode,
            sum(p.menuPrice*ph.quantity) as total_pirce
            FROM
            purchase AS ph
            JOIN
            product AS p ON p.menuCode = ph.product_MenuCode
            WHERE
            ph.userTable_CompanyCode = '{storeCode}'
            AND ph.tranDate LIKE '{date}%'
            GROUP BY
            ph.cartNum, ph.tranDate, ph.userTable_CompanyCode
            ORDER BY
            ph.tranDate DESC;
        """
        curs.execute(sql)
        rows = curs.fetchall()
        conn.close()
        result = [{"cartNum":row[0], "receiptLine":row[1], "sales_menus":row[2], "tranDate":row[3], "userTable_CompanyCode":row[4],"total_pirce":row[5]}for row in rows]
        return{"results":result}




