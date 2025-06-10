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

# 총 매장 별 매출 확인
@router.get('/select/companyCode/totalPrice')
async def selectCompanyCodewithTotalPrice():
    conn = connect()
    curs = conn.cursor()

    sql = f'''
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
    result = [{'companyCode': row[0], 'quantity': row[1], 'totalprice': row[2]}for row in rows]
    return {'results': result}

# 총 매장 별 매출 확인(년도 월별로 확인)
@router.get('/select/companyCode/totalPrice/month')
async def selectCompanyCodewithTotalPrice(year: str = "____", month : str="__"):
    conn = connect()
    curs = conn.cursor()

    sql = f'''
        SELECT 
        ph.userTable_CompanyCode,
        SUM(ph.quantity) AS total_quantity,
        SUM(pd.menuPrice * ph.quantity) AS total_price
        FROM ondam.purchase AS ph, ondam.product AS pd 
        where ph.product_MenuCode = pd.menuCode
        and ph.tranDate like "{year}-{month}%" 
        GROUP BY ph.userTable_CompanyCode
        ORDER BY total_price;
    '''
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    result = [{'companyCode': row[0], 'quantity': row[1], 'totalprice': row[2]}for row in rows]
    return {'results': result}

# 전체 메뉴 월별 매출
@router.get('/select/menuCode/')
async def selectMenuCodeMonth(year: str='____', month: str='__'):
    conn = connect()
    curs = conn.cursor()

    sql = f'''
        select pd.menuCode, pd.menuName,
        SUM(pd.menuPrice * ph.quantity) AS total_price
        from ondam.purchase AS ph, ondam.product AS pd 
        where ph.product_MenuCode = pd.menuCode and ph.tranDate Like '{year}-{month}%'
        group by pd.menuCode
        order by total_price;
        '''
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    result = [{'menuCode': row[0], 'menuName': row[1], 'totalPrice': row[2]} for row in rows]
    return {'results':result}


#------- 본사 년/월별 매출
@router.get('/select/select_year/month/total/date=')
async def select(year : str = '____', comCode : str = None):
    # Connection
    conn = connect()
    curs = conn.cursor()

    # SQL
    sql = f'''
    select sum(b.total_price) as total_price, b.tranDate
    from (
        select
            substring(ph.tranDate,1,7) as tranDate,
            sum(pd.menuPrice * ph.quantity) as total_price,
            ph.userTable_CompanyCode as companyCode
        from ondam.purchase as ph, ondam.product as pd 
        where ph.product_MenuCode = pd.menuCode and ph.tranDate Like "{year}%"
        GROUP BY ph.tranDate, ph.userTable_CompanyCode
        ORDER BY ph.tranDate
        )as b
    where b.companyCode = '{comCode}' 
    group by b.tranDate;
    '''
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    
    result = [{'total_price' : row[0], 'tran_date' : row[1]}for row in rows]
    return {'results' : result}


#------- 본사 월/일별 매출
@router.get('/select/select_month_day/total/date=')
async def select(year : str = '____', month : str = '__', comCode : str = None):
    # Connection
    conn = connect()
    curs = conn.cursor()

    # SQL
    sql = f'''
    select sum(b.total_price) as total_price, b.tranDate
    from (
        select
            substring(ph.tranDate,1,10) as tranDate,
            sum(pd.menuPrice * ph.quantity) as total_price,
            ph.userTable_CompanyCode as companyCode
        from ondam.purchase as ph, ondam.product as pd 
        where ph.product_MenuCode = pd.menuCode and ph.tranDate Like "{year}-{month}-%"
        GROUP BY ph.tranDate, ph.userTable_CompanyCode
        ORDER BY ph.tranDate
        ) as b
    where b.companyCode = '{comCode}'   
    group by b.tranDate;
    '''
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    
    result = [{'total_price' : row[0], 'tran_date' : row[1]}for row in rows]
    return {'results' : result}

#------- 본사 메인 상위 매출 3개 매장
@router.get('/select/day_top3_retailer')
async def select():
    # Connection
    conn = connect()
    curs = conn.cursor()

    # SQL
    sql = f'''
    select sum(pd.menuPrice) as total_price, ph.userTable_CompanyCode as companyCode
    from product as pd, purchase as ph
    where ph.tranDate like '2025-05%' and ph.product_MenuCode = pd.menuCode
    group by ph.userTable_CompanyCode;
    '''
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    
    result = [{'total_price' : row[0], 'companyCode' : row[1]}for row in rows]
    return {'results' : result}

# 직원 리스트
@router.get('/select/employee')
async def selectCompanyCodewithTotalPrice():
    conn = connect()
    curs = conn.cursor()

    sql = f'''
        select *
        from manager
    '''
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    result = [{'managerId': row[0], 'companyCode': row[1], 'managerPassword': row[2], 'location' : row[3]}for row in rows]
    return {'results': result}

#------- 본사 메인 금월 매출
@router.get('/select/main_month_day/total/date=')
async def select(year : str = '____', month : str = '__'):
    # Connection
    conn = connect()
    curs = conn.cursor()

    # SQL
    sql = f'''
    select sum(b.total_price) as total_price, b.tranDate
    from (
        select
            substring(ph.tranDate,1,10) as tranDate,
            sum(pd.menuPrice * ph.quantity) as total_price,
            ph.userTable_CompanyCode as companyCode
        from ondam.purchase as ph, ondam.product as pd 
        where ph.product_MenuCode = pd.menuCode and ph.tranDate Like "{year}-{month}-%"
        GROUP BY ph.tranDate, ph.userTable_CompanyCode
        ORDER BY ph.tranDate
        ) as b 
    group by b.tranDate;
    '''
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    
    result = [{'total_price' : row[0], 'tran_date' : row[1]}for row in rows]
    return {'results' : result}