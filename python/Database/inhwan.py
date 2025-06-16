from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import pymysql
import base64


router = APIRouter()
ip = "192.168.50.8"

class Table(BaseModel):
     
     userTable_TableNum: int
     userTable_CompanyCode: str
     manager_managerId : str
     date : str
     x : float
     y : float
     tableId : int

class Login(BaseModel):
    managerId : str
    managerPassword : str

class PurchaseItemRequest(BaseModel):
    # purchaseNum은 DB에서 자동 생성
    # cartNum: int # 서버에서 생성하므로 클라이언트 요청 모델에서 제거
    tableNum: str
    companyCode: str
    menuCode: str
    tranDate: str
    femaleNum: int = 0
    maleNum: int = 0
    quantity: int
    currentState: str = '주문' # 기본값 '주문'
    price_at_order: float # 주문 당시 가격

def connect():
        return pymysql.connect(
            host=ip,
            user="root",
            password="qwer1234", 
            db="ondam",           
            charset="utf8",
        )

@router.post("/selectUser")
async def selectUser(login : Login):
        conn = connect()
        curs = conn.cursor()
        sql = "SELECT count(*), companyCode From manager WHERE managerId =%s and managerPassword =%s"
        curs.execute(sql,(login.managerId, login.managerPassword,))
        rows = curs.fetchall()
        conn.close()
        result = [{"count":row[0], "companyCode":row[1]}for row in rows]
        return {'results' : result}

# 대리점에서 배치한 테이블 데이터베이스에 삽입
@router.post("/insert")
async def insert(table : Table) :
    # Connection
    conn = connect()
    curs = conn.cursor()

    # SQL 문장
    try :
        sql = "insert into management(userTable_TableNum, userTable_CompanyCode,manager_managerId, date ,x, y, tableId) values (%s,%s,%s,%s,%s,%s,%s)"
        curs.execute(sql, (table.userTable_TableNum, table.userTable_CompanyCode, table.manager_managerId, table.date, table.x,table.y,table.tableId))
        conn.commit()
        conn.close()
        return {'result':'OK'}
    except Exception as ex:
        conn.close
        print("Error :", ex)
        return{"result" : 'Error'}

# 대리점에 배치된 테이블 배치도 전에있던거 제거
@router.post("/delete")
async def delete(code):
    # Connection
    conn = connect()
    curs = conn.cursor()
    try:
        sql = "DELETE FROM management where userTable_CompanyCode=%s" # WHERE 절을 제거하여 모든 레코드 삭제
        curs.execute(sql, (code,)) 
        conn.commit()
        conn.close()
        return{'result':'OK'}
    except Exception as ex:
        conn.close()
        print("Error :", ex)
        return{"result" : 'Error'}
    


# 배치되있는 정보를 companyCode로 가져오기
@router.get("/get_objects")
async def get_objects(companyCode: str):
    conn = connect()
    # DictCursor를 사용하여 결과를 딕셔너리 형태로 가져옴
    curs = conn.cursor(pymysql.cursors.DictCursor)
    try:
        sql = "SELECT userTable_TableNum ,x, y, tableId FROM management where userTable_CompanyCode=%s"
        curs.execute(sql, (companyCode,))
        results = curs.fetchall() # 모든 행 가져오기
        conn.close()
        return results
    except Exception as ex:
        conn.close()

        return {"result": "Error", "message": str(ex)}
    
@router.get("/get_products")
async def get_products():
    conn = connect()
    curs = conn.cursor(pymysql.cursors.DictCursor)
    try:
        sql = "SELECT menuCode, menuName, menuPrice, menuImage, description FROM product"
        curs.execute(sql)
        results = curs.fetchall() 
        conn.close()

        # BLOB 데이터를 Base64 문자열로 변환하여 반환
        processed_results = []
        for row in results: # row는 이제 딕셔너리입니다.
            # 딕셔너리이므로 copy()를 사용할 수 있습니다.
            processed_row = row.copy()
            if processed_row['menuImage'] is not None:
                processed_row['menuImage'] = base64.b64encode(processed_row['menuImage']).decode('utf-8')
            processed_results.append(processed_row)

        return processed_results

    except Exception as ex:
        conn.close()
        print("Error fetching products:", ex)
        raise HTTPException(status_code=500, detail=f"메뉴 데이터 로드 중 서버 오류 발생: {ex}")



# 새로운 엔드포인트: 주문 접수 (POST 요청)
# 여러 주문 항목을 리스트로 받습니다.
@router.post("/place_order")
async def place_order(order_items: list[PurchaseItemRequest]):
    if not order_items:
        raise HTTPException(status_code=400, detail="주문 항목이 없습니다.")

    conn = connect()
    curs = conn.cursor()

    try:
        # 1. 현재 purchase 테이블의 최대 cartNum을 가져옵니다.
        curs.execute("SELECT MAX(cartNum) FROM purchase")
        max_cart_num_result = curs.fetchone() # DictCursor 사용 시 딕셔너리, 아니면 튜플
        # 결과가 딕셔너리 형태일 경우 'MAX(cartNum)' 키로 접근
        max_cart_num = max_cart_num_result['MAX(cartNum)'] if isinstance(max_cart_num_result, dict) else max_cart_num_result[0]

        # 2. 새로운 cartNum을 계산합니다. (테이블이 비어있으면 1부터 시작)
        new_cart_num = (max_cart_num or 0) + 1 # max_cart_num이 None이면 0으로 처리

        # 3. 여러 주문 항목을 한 번에 삽입
        sql = """
        INSERT INTO purchase
        (cartNum, userTable_TableNum, userTable_companyCode, product_MenuCode, tranDate, femaleNum, maleNum, quantity, currentState, price_at_order)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """

        # 삽입할 데이터 리스트 생성
        values = [
            (
                new_cart_num, # 생성된 새로운 cartNum 사용
                item.tableNum,
                item.companyCode,
                item.menuCode,
                item.tranDate,
                item.femaleNum,
                item.maleNum,
                item.quantity,
                item.currentState,
                item.price_at_order
            )
            for item in order_items
        ]

        # executemany를 사용하여 여러 행 삽입
        curs.executemany(sql, values)

        conn.commit()
        conn.close()

        return {"result": "OK", "message": f"{len(order_items)}개 항목 주문 접수 완료 (CartNum: {new_cart_num})"}

    except Exception as ex:
        conn.rollback() # 오류 발생 시 롤백
        conn.close()
        print("Error placing order:", ex)
        raise HTTPException(status_code=500, detail=f"주문 처리 중 오류 발생: {ex}")
    


# /get_table_orders/{table_num} 엔드포인트 (LoadPage2 다이얼로그에서 테이블 주문 내역 가져올 때 사용)
@router.get("/get_table_orders/{table_num}/{companyCode}")
async def get_table_orders(table_num: str, companyCode: str):
    conn = connect()
    curs = conn.cursor(pymysql.cursors.DictCursor)
    try:
        # purchase 테이블과 product 테이블을 JOIN하여 메뉴 이름과 가격을 함께 가져옴
        # 해당 tableNum의 '주문' 상태인 항목만 필터링
        sql = """
        SELECT
            p.menuName,
            p.menuPrice,
            pur.quantity,
            pur.price_at_order,
            pur.cartNum,
            pur.purchaseNum
        FROM purchase pur
        JOIN product p ON pur.product_MenuCode = p.menuCode
        WHERE pur.userTable_TableNum = %s AND pur.userTable_CompanyCode = %s AND pur.currentState = '주문'
        """
        curs.execute(sql, (table_num,companyCode,))
        results = curs.fetchall()
        conn.close()
        return results

    except Exception as ex:
        conn.close()
        print(f"Error fetching orders for table {table_num}:", ex)
        raise HTTPException(status_code=500, detail=f"주문 내역 로드 중 서버 오류 발생: {ex}")


# 주문 상태 결제로 바꾸기
@router.put("/update_order_state_to_completed/{table_num}/{companyCode}")
async def update_order_state_to_completed(table_num: str, companyCode: str):
    conn = connect()
    curs = conn.cursor()
    try:
        sql = """
        UPDATE purchase
        SET currentState = '결제'
        WHERE userTable_TableNum = %s AND userTable_CompanyCode = %s AND currentState = '주문'
        """
        curs.execute(sql, (table_num,companyCode,))
        conn.commit()
        conn.close()
        return {"result": "OK", "message": f"{table_num} 번 테이블의 주문이 결제 완료되었습니다."}

    except Exception as ex:
        conn.rollback()
        conn.close()
        print(f"Error updating order state for table {table_num}:", ex)
        raise HTTPException(status_code=500, detail=f"주문 상태 업데이트 중 서버 오류 발생: {ex}")

        print("Error fetching data:", ex)
        # 오류 발생 시 오류 메시지 포함하여 반환
        return {"result": "Error", "message": str(ex)}

