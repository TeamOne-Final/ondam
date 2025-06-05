from fastapi import FastAPI
from pydantic import BaseModel
import pymysql

app = FastAPI()

def connect():
    conn = pymysql.connect(
        host = '192.168.50.8',
        user = 'root',
        password = 'qwer1234',
        database = 'ondam',
        charset = 'utf8'
    )
    return conn
# -- 전체 쿼리문
@app.get('/select/all')
async def select():
    # Connection
    conn = connect()
    curs = conn.cursor()

    # SQL
    sql = '''
    select ph.userTable_TableNum, ph.userTable_CompanyCode, ph.product_MenuCode, ph.cartNum, ph.tranDate, ph.femaleNum,maleNum, ph.quantity, pd.menuPrice*ph.quantity
    from ondam.purchase as ph, ondam.product as pd
    where ph.product_MenuCode = pd.menuCode
    order by tranDate;
    '''
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    
    # 결과 값을 Dictionary로 변환
    result = [{'userTable_TableNum' : row[0], 'userTable_CompanyCode' : row[1], 'product_MenuCode' : row[2], 'cartNum' : row[3], 'tranDate' : row[4], 'femaleNum': row[5], 'maleNum':row[6], 'quantity' : row[7], 'Price' : row[8]}for row in rows]
    return {'results' : result}

#----- 매장 별 누적 총 매출
@app.get('/select/totalPrice')
async def select():
    # Connection
    conn = connect()
    curs = conn.cursor()

    # SQL
    sql = '''
    SELECT 
    ph.userTable_CompanyCode,
    SUM(ph.quantity) AS total_quantity,
    SUM(pd.menuPrice * ph.quantity) AS total_price
    FROM ondam.purchase AS ph, ondam.product AS pd 
    where ph.product_MenuCode = pd.menuCode
    GROUP BY ph.userTable_CompanyCode
    ORDER BY total_price desc; 
    '''
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    
    result = [{'userTable_CompanyCode' : row[0], 'total_quantity' : row[1], 'total_price' : row[2]}for row in rows]
    return {'results' : result}

#----- 메뉴 별 누적 총 매출
@app.get('/select/menu_totalPrice')
async def select():
    # Connection
    conn = connect()
    curs = conn.cursor()

    # SQL
    sql = '''
    select pd.menuName,
    sum(ph.quantity) as total_quantity,
    sum(pd.menuPrice * ph.quantity) as total_price
    from ondam.purchase AS ph, ondam.product AS pd 
    where ph.product_MenuCode = pd.menuCode
    group by pd.menuCode;
    '''
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    
    result = [{'menuName' : row[0],'total_quantity' : row[1] ,'total_price' : row[2]}for row in rows]
    return {'results' : result}


#------- 매장 날짜별 매출
@app.get('/select/select_store_date_total/date={year}-{month}-{day}')
async def select(year : str,month : str,day : str):
    # Connection
    conn = connect()
    curs = conn.cursor()

    # SQL
    sql = f'''
    select b.userTable_companyCode, sum(total_price)
    from (
        select
        ph.userTable_CompanyCode,
        ph.tranDate,
        sum(pd.menuPrice * ph.quantity) as total_price
        from ondam.purchase as ph, ondam.product as pd 
        where ph.product_MenuCode = pd.menuCode and ph.tranDate Like "{year}-{month}-{day}%"
        GROUP BY ph.tranDate, ph.userTable_CompanyCode
        ORDER BY ph.tranDate
        ) as b
    group by b.usertable_companyCode;
    '''
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    
    result = [{'userTable_CompanyCode' : row[0], 'total_price' : row[1]}for row in rows]
    return {'results' : result}

#------- 날짜별 매출
@app.get('/select/select_date_total/date={year}-{month}-{day}')
async def select(year : str, month : str, day : str):
    # Connection
    conn = connect()
    curs = conn.cursor()

    # SQL
    sql = f'''
    select sum(b.total_price) as total_price
    from (
	    select
        ph.tranDate,
        sum(pd.menuPrice * ph.quantity) as total_price
        from ondam.purchase as ph, ondam.product as pd 
        where ph.product_MenuCode = pd.menuCode and ph.tranDate Like "{year}-{month}-{day}%"
        GROUP BY ph.tranDate, ph.userTable_CompanyCode
        ORDER BY ph.tranDate
    ) as b;
    '''
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    
    result = [{'total_price' : row[0]}for row in rows]
    return {'results' : result}



if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host = '127.0.0.1', port = 8000)