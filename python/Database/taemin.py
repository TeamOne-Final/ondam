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

#------- cartNum 최댓값 구하기 
@router.get('/select/max_cartNum')
async def getMaxCartNum():
    # Connection
    conn = connect()
    curs = conn.cursor()

    # SQL
    sql = f'''
    select max(cartNum) from purchase;
    '''
    curs.execute(sql)
    row = curs.fetchone()
    conn.close()
    
    result = [{'max_cartNum' : row[0]}]
    return {'results' : result}

#------- purcahse 추가 
@router.post('/insert/purchase')
async def insertPurcha(cartNum : int, tableNum : int, companyCode : str, menuCode : str, femaleNum:int,maleNum:int,quantity:int):
    # Connection
    conn = connect()
    curs = conn.cursor()

    # SQL
    sql = f'''
    insert into purchase (
    userTable_TableNum, userTable_CompanyCode, product_MenuCode,
    cartNum, tranDate,femaleNum,
    maleNum, quantity
    ) 
    values 
    ({tableNum}, '{companyCode}', '{menuCode}', {cartNum}, now(), {femaleNum}, {maleNum}, {quantity});
    '''
    try:
        curs.execute(sql)
        conn.commit()
        conn.close()

        return {'results' : 'OK'}
    except Exception as e:
        conn.close()
        print('Error : ', e)
        return{'result' : 'Error'}

#---- purchase 데이터 갱신
@router.post("/update/purchase")
async def updatePurchase(quantity : int, cartNum : int, menuCode : str):
    # Connection으로 부터 Cursor 생성
    conn = connect()
    curs = conn.cursor()

    # SQL 문장
    try:
        sql = f"""
        update purchase set quantity = {quantity} where cartnum = {cartNum} and product_menuCode = '{menuCode}'
        """
        curs.execute(sql)
        conn.commit()
        conn.close()
        return {'result':'OK'}  
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'result':'Error'}

#---- purchase 데이터 삭제
@router.delete("/delete/purchase")
async def deletePurchase(cartNum: int, menuCode : str):
    # Connection으로 부터 Cursor 생성
    conn = connect()
    curs = conn.cursor()

    # SQL 문장
    try:
        sql = f"""
        delete from purchase where cartNum = {cartNum}  and product_menuCode = '{menuCode}'
        """
        curs.execute(sql)
        conn.commit()
        conn.close()
        return {'result':'OK'}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'result':'Error'}
    
#-- 대리점 메뉴 선택
@router.post('/insert/select')
async def insertSelect(menuCode : str, companyId : str):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = f'''
        insert into ondam.select 
        (product_MenuCode, manager_CompanyId, date)
        values ('{menuCode}','{companyId}',now())
        '''

        curs.execute(sql)
        conn.commit()
        conn.close()
        return {'result':'OK'}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'result':'Error'}

#-- 대리점 메뉴 삭제
@router.delete('/delete/select')
async def deleteSelect(menuCode : str, companyId : str):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = f'''
        delete from ondam.select 
        where product_MenuCode = '{menuCode}' and manager_CompanyId = '{companyId}'
        '''

        curs.execute(sql)
        conn.commit()
        conn.close()
        return {'result':'OK'}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'result':'Error'}
    
#-- 상품 분석 페이지 데이터
@router.get('/select/product_anal/total')
async def select(firstDate : str,finalDate : str,companyCode : str
                ):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = f'''
        select sum(ph.quantity) as total_quantity, sum(pd.menuPrice * ph.quantity) as total_price
        from purchase as ph, product as pd
        where ph.product_menuCode = pd.menuCode and Date(ph.tranDate) >= '{firstDate}' and Date(ph.tranDate) < '{finalDate}' and ph.userTable_CompanyCode = '{companyCode}';
        '''

        curs.execute(sql)
        row = curs.fetchone()
        conn.close()
    
        result = [{'total_quantity' : row[0], 'total_price' : row[1]}]
        return {'results' : result}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'result':'Error'}
    
#-- 상품 분석 페이지 차트 데이터
@router.get('/select/product_anal/chart')
async def select(firstDate : str,finalDate : str,companyCode : str 
                ):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = f'''
        select pd.menuName, sum(ph.quantity) as total_quantity, sum(pd.menuPrice * ph.quantity) as total_price
        from purchase as ph, product as pd
        where ph.product_menuCode = pd.menuCode and Date(ph.tranDate) >= '{firstDate}' and Date(ph.tranDate) < '{finalDate}' and ph.userTable_CompanyCode = '{companyCode}'
        group by pd.menuName
        order by total_price desc;
        '''

        curs.execute(sql)
        rows = curs.fetchall()
        conn.close()
    
        result = [{'menuName' : row[0], 'total_quantity' : row[1], 'total_price' : row[2]}for row in rows]
        return {'results' : result}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'result':'Error'}
    
#-- 매출 현황 페이지 데이터
@router.get('/select/purchase/data')
async def select(storeCode: str = None, firstDate: str = None, finalDate: str = None):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = f'''
        select sum(b.total_price) as total_price, count(b.purchase_count) as purchase_count,
            (select count(*) from purchase as ph where ph.quantity < 0 and ph.tranDate >= '{firstDate}' and ph.tranDate < '{finalDate}') as refund_count, 
            (select abs(sum(ph.quantity * pd.menuPrice)) from purchase as ph, product as pd where ph.product_MenuCode = pd.menuCode and ph.quantity < 0 and ph.tranDate >= '{firstDate}' and ph.tranDate < '{finalDate}') as refund_price
                from(select sum(ph.quantity * pd.menuPrice) as total_price, count(*) as purchase_count
	    from purchase as ph, product as pd
	    where ph.product_menuCode = pd.menuCode
        and ph.tranDate >= '{firstDate}'
	    and ph.tranDate < '{finalDate}'
        and ph.userTable_CompanyCode like '{storeCode}%'
	    group by ph.cartNum) as b;
        '''

        curs.execute(sql)
        rows = curs.fetchall()
        conn.close()
    
        result = [{'total_price' : row[0], 'purchase_count' : row[1], 'refund_count' : row[2], 'refund_price' : row[3]}for row in rows]
        return {'results' : result}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'result':'Error'}
    
#-- 매출 현황 페이지 기간 비교 그래프
@router.get('/select/purchase/chart')
async def select(storeCode: str = None, firstDate: str = None, finalDate: str = None):
    conn = connect()
    curs = conn.cursor()

    try:
        select_period_sql = f'''
        select sum(b.price), 
        CONCAT(
            Date('{firstDate}'),
            ' ~ ',
            Date('{finalDate}')
        ) AS date
        from (
        select Date(ph.trandate) as date, sum(pd.menuprice) as price
		    from purchase as ph, product as pd
		    where ph.product_menucode = pd.menucode
		    and ph.usertable_companyCode = '{storeCode}'
            and ph.trandate < '{finalDate}'
            and ph.trandate >= '{firstDate}'
            group by Date(ph.trandate)
	    ) as b;
        '''

        pre_preiod_sql = f'''
        SELECT 
        SUM(b.price), 
        CONCAT(
            DATE_FORMAT(DATE_SUB(DATE_SUB('{firstDate}', INTERVAL 1 DAY), INTERVAL DATEDIFF('{finalDate}', '{firstDate}') DAY), '%Y-%m-%d'),
            ' ~ ',
            DATE_FORMAT(DATE_SUB('{firstDate}', INTERVAL 1 DAY), '%Y-%m-%d')
        ) AS date
        FROM (
	        SELECT DATE(ph.trandate) AS date, SUM(pd.menuprice) AS price
	        FROM purchase AS ph
	        JOIN product AS pd ON ph.product_menucode = pd.menucode
	        WHERE ph.usertable_companyCode = '{storeCode}'
	        and ph.trandate < '{firstDate}' - interval 1 day
	        and ph.trandate >= ('{firstDate}' - interval 1 day) - INTERVAL datediff('{finalDate}', '{firstDate}') day
            GROUP BY DATE(ph.trandate)
        ) AS b;
        '''

        curs.execute(select_period_sql)
        datenow = curs.fetchone()
        nowresult = [{'now_total_price' : datenow[0], 'nowdate' : datenow[1]if datenow else []}]

        curs.execute(pre_preiod_sql)
        datebefore = curs.fetchone()
        preresult = [{'pre_total_price' : datebefore[0], 'predate' : datebefore[1] if datebefore else []}]
        conn.close()
    
        return {'results' : [nowresult, preresult]}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'result':'Error'}
    
#-- 주문/계약 페이지 데이터 로딩
@router.get('/select/order')
async def select():
    conn = connect()
    curs = conn.cursor()

    try:
        sql = f'''
        select dv.deliverycontractnum, fc.factoryname, mng.companycode, igd.ingredientname, dv.deliveryprice, dv.deliveryquantity, dv.deliverydate, dv.contractdate
        from delivery as dv, manager as mng, ingredient as igd, factory as fc
        where dv.manager_managerid = mng.managerid 
        and dv.ingredient_ingredientcode = igd.ingredientcode
        and fc.factorycode = dv.factory_factorycode
        order by dv.deliveryDate;
        '''

        curs.execute(sql)
        rows = curs.fetchall()
        conn.close()
    
        result = [{'contractNum' : row[0],'factoryName' : row[1], 'companyCode' : row[2], 'ingredientName' : row[3],'deliveryPrice' : row[4], 'deliveryQuantity' : row[5], 'deliveryDate' : '' if row[6] == None else row[6],'contractDate' : row[7]}for row in rows]
        return {'results' : result}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'result':'Error'}
    
#---- 주문 추가
@router.post('/insert/delivery')
async def insertSelect(factorycode : str, ingredientcode : str, managerid : str, quantity : int):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = f'''
        insert into delivery 
        (factory_factorycode, ingredient_ingredientcode, 
        manager_managerid, deliveryprice, deliveryquantity, 
        deliverydate, contractdate) 
        values ('{factorycode}','{ingredientcode}','{managerid}',
        (select igd.ingredientprice from ingredient as igd where igd.ingredientcode = "{ingredientcode}")*{quantity},
        {quantity},null,now());
        '''

        curs.execute(sql)
        conn.commit()
        conn.close()
        return {'result':'OK'}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'result':'Error'}
    
#---- 주문 도착일 갱신
@router.post("/update/delivery")
async def updatePurchase(contractNum : int):
    # Connection으로 부터 Cursor 생성
    conn = connect()
    curs = conn.cursor()

    # SQL 문장
    try:
        sql = f"""
        update delivery set deliverydate = now() where deliverycontractnum = {contractNum};
        """
        curs.execute(sql)
        conn.commit()
        conn.close()
        return {'result':'OK'}  
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'result':'Error'}

#-- 대리점 메뉴 삭제
@router.delete('/delete/sasda')
async def deleteSelect(menuCode : str, companyId : str):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = f'''
        delete from ondam.select 
        where product_MenuCode = '{menuCode}' and manager_CompanyId = '{companyId}'
        '''

        curs.execute(sql)
        conn.commit()
        conn.close()
        return {'result':'OK'}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'result':'Error'}
