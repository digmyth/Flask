import threading

def run():
    pool = SingletonDBPool()
    con = pool.connect()
    cursor = conn.cursor()
    cursor.execute('select * from tb1')
    result = cursor.fetchall()
    cursor.close()
    con.close()


for i in range(10)
    

func()
