#- random을 이용해 1~100의 숫자를 지정한다.(공개X)
#- 숫자를 입력하게 한다. (숫자를 입력하시오: XX)
#- 정답보다 숫자가 크면 DOWN, 정답보다 숫자가 작으면 UP을 출력한다. 정답이면
#RIGHT을 출력한다.
#- 정답을 맞출 때까지 위 과정을 반복한다.

import random

rannum=random.randint(1,100)

while True:
    asknum=int(input("숫자를 입력하세요: "))

    if rannum>asknum:
        print("UP")

    elif rannum<asknum:
        print("DOWN")

    else:
        print("RIGHT")
        break

