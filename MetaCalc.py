from tkinter import *

calc=Tk()

calc.title("Basic Metabolic Rate Calculator")
calc.geometry("640x440+100+100")
calc.resizable(False,False)

label_1=Label(calc, text="기초대사량 계산기", relief="solid", fg="Blue", font=("한컴윤고딕 240", 15))
label_1.place(x=0,y=0)

label_2=Label(calc, text="기초대사량이란?", relief="ridge", fg="Blue", font=("한컴윤고딕 240", 12))
label_2.place(relx=0.55,rely=0.2)

label_2=Label(calc, text="기초대사량이란?", relief="ridge", fg="Blue", font=("한컴윤고딕 240", 12))
label_2.place(relx=0.55,rely=0.2)

label_3=Label(calc, text="생물체가 생명을 유지하는데 필요한 \n최소한의 에너지량을 말합니다.\n가만히 있을 때 기초대사량만큼의\n에너지가 소모됩니다.", fg="Black", font=("맑은고딕", 10), justify="left")
label_3.place(relx=0.55,rely=0.26)

label_4=Label(calc, text="성별", fg="Black", relief="groove", font=("한컴윤고딕 250", 12))
label_4.place(relx=0.02,rely=0.2)

label_5=Label(calc, text="나이", fg="Black", relief="groove", font=("한컴윤고딕 250", 12))
label_5.place(relx=0.02,rely=0.3)

label_6=Label(calc, text="신장", fg="Black", relief="groove", font=("한컴윤고딕 250", 12))
label_6.place(relx=0.02,rely=0.4)

label_7=Label(calc, text="체중", fg="Black", relief="groove", font=("한컴윤고딕 250", 12))
label_7.place(relx=0.02,rely=0.5)

def age():
    age1=int(entry_1.get())
    return age1

entry_1=Entry(calc)
entry_1.place(relx=0.1, rely=0.3)

def ki():
    ki1=int(entry_2.get())
    return ki1

entry_2=Entry(calc)
entry_2.place(relx=0.1, rely=0.4)

def weight():
    weight1=int(entry_3.get())
    return weight1

entry_3=Entry(calc)
entry_3.place(relx=0.1, rely=0.5)

def check1():
    if RadioVariety_1.get()==1:
        num=655.1+(9.56*weight())+(1.85*ki())-(4.68*age())
        return num

    elif RadioVariety_1.get()==2:
        num=66.47+(13.75*weight())+(5*ki())-(6.76*age())
        return num

def button1():
    button.config(text=str(check1()))

button=Button(calc, command=button1, text="확인" )
button.place(relx=0.1, rely=0.6)

RadioVariety_1=IntVar()

radio1=Radiobutton(calc, text="여자", value=1,variable=RadioVariety_1, command=check1)
radio1.place(relx=0.1, rely=0.2)

radio2=Radiobutton(calc, text="남자",  value=2,variable=RadioVariety_1, command=check1)
radio2.place(relx=0.2, rely=0.2)


calc.mainloop()
