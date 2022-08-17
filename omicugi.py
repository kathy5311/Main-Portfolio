from textwrap import fill
from tkinter import *
import random
from PIL import ImageTk

luck=Tk()
luck.title("오미쿠지")
luck.geometry("683x512")
luck.resizable(False, False)

canvas=Canvas(luck,width=1200,height=1000)
canvas.pack()
gong=ImageTk.PhotoImage(file='C:\\Users\\정윤서\\Desktop\\gong.png')

shapes=canvas.create_image(340,250,image=gong)

label_1=Label(luck, text="내 운세를 점쳐보자", width=30, height=3, relief="solid", fg="white", bd=4, bg='black', font=('마른고딕',20))
label_1.place(relx=0.125, y=10)

count=""

def ran():
    global count
    a= random.randint(1,7)

    if a==1:
        count= "대길입니다.\n엄청난 행운이 당신과 함께 할거에요!"

    elif a==2:
        count= "길입니다.\n힘차게 살다보면 행운이 따를거에요."
        
    elif a==3:
        count="중길입니다.\n뜻밖의 행운이 찾아올거에요."
        
    elif a==4:
        count="소길입니다.\n일상 속 소소한 행복이 찾아올거에요."
        
    elif a==5:
        count="말길입니다.\n아직은 행운의 징조가 보이진 않지만 \n조금씩 좋은 일이 일어날 거에요."
        
    elif a==6:
        count="흉입니다.\n무모한 도전은 멈춰주세요."
        
    else:
        count="대흉입니다.\n하루하루 아무일 없도록 기도하세요."
    
    label.config(text=str(count))

        


label=Label(luck,relief="groove",text="Start!",font=("맑은 고딕", 15), width=30,height=3)
label.place(relx=0.235,rely=0.5)

button=Button(luck, text='Click!',relief='solid', overrelief="solid", width=15, command=ran, repeatdelay=1000, repeatinterval=100)
button.place(relx=0.395,rely=0.3)

luck.mainloop()