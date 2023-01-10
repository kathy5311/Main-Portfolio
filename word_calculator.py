#조건
#저장한 파일(article.txt)를 읽고 그 파일에 저장된 각 단어가 나타나는 횟수를 계산하고 상위
#3개의 단어와 그 횟수를 출력하시오
#알파벳이 아닌 단어는 무시하고 대문자를 소문자로 전환-0
#내장함수는 사용 가능하되, 모듈을 import 하지 않음-0
#article.txt 내의 단어 개수를 계산한다-0
#상위3개의 단어와 그 개수를 출력한다-0

file = open("article.txt", "r", encoding='UTF8')
new_word=[]
alpha=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',"'"]
while True:
    para = file.read()
    para=para.lower()
    if not para:
        break
    
    r_para=para.split()
    i=0
    count=0

    for i in range(len(r_para)):
        # 알파벳이 아닌 것 제외
        if r_para[i][0] not in alpha:
            r_para[i]=r_para[i][1:]
            
        elif r_para[i][-1] not in alpha:
            r_para[i]=r_para[i][:-1]
        
        else:
            pass

        # article.txt 내 단어의 개수        
        if r_para[i] not in new_word:
            new_word.append(r_para[i])
            count+=1
        else:
            pass

    #단어개수
    j=0
    word_dict={}
    for j in range(len(r_para)):
        sum=0
        sum=para.count(r_para[j])
        word_dict[r_para[j]]=sum
    
    new_dict={v:k for k,v in word_dict.items()}

    new_list=[]
    for val in word_dict.values():
        new_list.append(val)
        
    new_list.sort()

    #최빈 3단어 출력
    i=1
    for k in range(1,4):
        frequent=new_dict.get(new_list[-k])
        wordcount=word_dict[frequent]
        print("{} 번째 최빈값: {}, {}개".format(i,frequent,wordcount))
        i+=1
    
    print("전체 단어 개수:",count)

file.close()

