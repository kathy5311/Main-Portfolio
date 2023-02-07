#- random을 이용해 3자리 숫자를 고른다. (공개X)
#- 세자리 숫자를 입력하게 한다. (숫자를 입력하시오: XXX)
#- 숫자야구 규칙 그대로 적용:

import random

newlist=[]
for i in range(3):
    corrnum=str(random.randint(0,9))
    newlist.append(corrnum)



while True:

    asknum=input("숫자를 입력하세요: ")
    
    asklist=[]
    for i in range(len(asknum)):
        asklist.append(asknum[i])

    count_ball=0
    count_strike=0
    count_out=0

    for word_num in range(len(asklist)):
        if asklist[word_num] in newlist:
            if asklist[word_num] == newlist[word_num]:
                count_strike+=1
            else:
                count_ball+=1
        else:
            count_out+=1
    print("{}s, {}b, {}out".format(count_strike,count_ball,count_out))

    if count_strike==3:
        break


