from fastapi import APIRouter
from pydantic import BaseModel
import pymysql


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

    # SQL 문장 (모든 레코드 삭제)
    try:
        sql = "DELETE FROM management where userTable_CompanyCode=%s" # WHERE 절을 제거하여 모든 레코드 삭제
        curs.execute(sql, (code,)) # 매개변수가 없으므로 ()를 생략하거나 빈 튜플을 사용합니다.
        conn.commit()
        conn.close()
        return{'result':'OK'}
    except Exception as ex:
        # conn.close()는 함수 호출이므로 괄호를 붙여야 합니다.
        conn.close()
        print("Error :", ex)
        return{"result" : 'Error'}
    
    # 새로운 엔드포인트: 데이터베이스의 모든 객체 데이터를 가져옴 (GET 요청)

# 배치되있는 정보를 compantCode로 가져오기
@router.get("/get_objects")
async def get_objects(companyCode: str):
    conn = connect()
    # DictCursor를 사용하여 결과를 딕셔너리 형태로 가져옴
    curs = conn.cursor(pymysql.cursors.DictCursor)
    try:
        # 'move' 테이블에서 모든 데이터 선택
        sql = "SELECT userTable_TableNum ,x, y, tableId FROM management where userTable_CompanyCode=%s"
        curs.execute(sql, (companyCode,))
        results = curs.fetchall() # 모든 행 가져오기
        conn.close()
        # results는 이미 딕셔너리 리스트 형태이므로 바로 반환 가능
        return results
    except Exception as ex:
        # conn.close()는 함수 호출이므로 괄호를 붙여야 합니다.
        conn.close()
        print("Error fetching data:", ex)
        # 오류 발생 시 오류 메시지 포함하여 반환
        return {"result": "Error", "message": str(ex)}
