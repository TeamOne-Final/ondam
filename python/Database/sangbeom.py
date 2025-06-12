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

@router.get('/select/eachstore/curTointernal29')
async def selectEachStoreCurToInternal(storeCode: str = None):
        conn = connect()
        curs = conn.cursor()
        sql = f'''
        select
        ph.userTable_CompanyCode,
        Date(ph.tranDate),
        sum(pd.menuPrice * ph.quantity) as total_price
        from ondam.purchase as ph, ondam.product as pd 
        where ph.product_MenuCode = pd.menuCode
        and ph.tranDate >=  curdate() - interval 29 day
        and ph.tranDate < curdate() + interval 1 day
        and ph.userTable_CompanyCode like '{storeCode}%'
        GROUP BY Date(ph.tranDate), ph.userTable_CompanyCode
        ORDER BY Date(ph.tranDate);
        '''
        curs.execute(sql)
        rows = curs.fetchall()
        conn.close()
        result = [{'CompanyCode': row[0], 'tranDate': row[1], 'totalPrice': row[2]}for row in rows]
        return {'results': result}


@router.get('/select/eachstore/firstDatetofinalDate')
async def selectEachStoreFirstDatetoFinalDate(storeCode: str = None, firstDate: str = None, finalDate: str = None):
        conn = connect()
        curs = conn.cursor()
        sql = f'''
        select
        ph.userTable_CompanyCode,
        Date(ph.tranDate),
        sum(pd.menuPrice * ph.quantity) as total_price,
        sum(sum(pd.menuPrice * ph.quantity))
        over(
        partition by ph.userTable_CompanyCode
        order by Date(ph.tranDate)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cumulative_total_price,
        count(*) as sales_count,
        sum(count(*))
        over(
        partition by ph.userTable_CompanyCode
        order by Date(ph.tranDate)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cumulative_total_sales_count
        from ondam.purchase as ph, ondam.product as pd 
        where ph.product_MenuCode = pd.menuCode
        and ph.tranDate >= '{firstDate}'
        and ph.tranDate < '{finalDate}'
        and ph.userTable_CompanyCode like '{storeCode}%'
        GROUP BY Date(ph.tranDate), ph.userTable_CompanyCode
        ORDER BY Date(ph.tranDate);
        '''
        curs.execute(sql)
        rows = curs.fetchall()
        conn.close()
        result = [{'companyCode': row[0], 'tranDate': row[1], 'totalPrice': row[2], 'cumulativeTotalPrice': row[3], 'salesCount': row[4],'cumulativeSalesCount':row[5]}for row in rows]
        return {'results': result}


@router.get('/select/sales/counts')
async def selectTotalSalesCounts(storeCode : str = None, firstDate : str = None, finalDate : str = None):
        conn = connect()
        curs = conn.cursor()
        sql = f'''
                select sum(pd.menuPrice * ph.quantity) as total_prices,
                (count(distinct(ph.cartNum))) as count_cartNum,
                (select count(*) from purchase as ph where ph.quantity < 0 and ph.tranDate >= '{firstDate}'
                and ph.tranDate < '{finalDate}') as refundcount,
                (select abs(sum(ph.quantity * pd.menuPrice)) from purchase as ph, product as pd where ph.product_MenuCode = pd.menuCode and ph.quantity < 0 and ph.tranDate >= '{firstDate}'
                and ph.tranDate < '{finalDate}') as refundPrice
                from ondam.purchase as ph, ondam.product as pd
                where ph.product_MenuCode = pd.menuCode
                and ph.tranDate >= '{firstDate}'
                and ph.tranDate < '{finalDate}'
                and ph.userTable_CompanyCode like '{storeCode}';

        '''
        curs.execute(sql)
        row = curs.fetchone()
        conn.close()
        result = {'totalPrices':row[0], 'countCartNum': row[1], 'refundCount': row[2], 'refundPrice': 0 if row[3] == None else row[3]}
        return{'results':[result]}