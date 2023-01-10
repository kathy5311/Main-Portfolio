from tkinter import *
from tkinter import ttk
from tkinter import messagebox
from tkinter import font


memo=Tk()
memo.geometry("440x360+200+100")
memo.title("Make Checklist")
memo.resizable(True,True)

checklist=[]
count=0

# 삭제 기능
def delete():
    selection=listbox.curselection()
    value=listbox.get(selection[0]) ##selection값은 리스트 형태로 반환
    ind=checklist.index(value)
    del checklist[ind]
    listbox.delete(ind)
    
# 추가 기능
def insert():
    global entry
    value=entry.get()
    checklist.append(value)
    listbox.insert(END, value)
    entry.delete(0,END)

# 우선 순위 끌어올리기
def highlight():
    selection=listbox.curselection()
    value=listbox.get(selection[0])
    ind=checklist.index(value)
    checklist.remove(value)
    checklist.insert(0,value)
    listbox.delete(ind)
    listbox.insert(0,value)

# 모두 삭제
def aldel():
    check=messagebox.askokcancel("메세지 상자","모두 삭제하시겠습니까?")
    if check==True:
        listbox.delete(0, END)
        checklist.clear()

    else:
        messagebox.showinfo('check', '실행 취소되었습니다.')

# 과제 개수
def counting():
    global count
    for i in range(len(checklist)):
        count+=1
    label.config(text="Number of Tasks: "+str(count))

# 수정
def modi():
    selection=listbox.curselection()
    ind=listbox.index(selection)
    value_1=listbox.get(selection[0])
    check=messagebox.askokcancel("메세지 상자",str(value_1)+'를/을 수정하시겠습니까?')
    if check==True:
        listbox.delete(ind)
        value=entry.get()
        listbox.insert(ind,value)
        entry.delete(0,END)
    else:
        messagebox.showinfo('check', '실행 취소되었습니다.')
        entry.delete(0,END)


# 스크롤바(listbox)
frame=ttk.Frame(memo)
scrollbar= ttk.Scrollbar(frame)
scrollbar.pack(side="right", fill="y")
frame.pack()

listbox=Listbox(frame,yscrollcommand = scrollbar.set, width=50)
listbox.pack()

scrollbar["command"]=listbox.yview

style= ttk.Style()
style.configure("BW.TLabel", foreground="black", background="white")
font=font.Font(size=10)
label=ttk.Label(text="Number of Tasks:", style="BW.TLabel", relief="solid", font=font)
label.pack()

entry= ttk.Entry(memo, width=40)
entry.pack()

# 버튼 종류
buttonDel=ttk.Button(memo, text="Delete", command=delete, width=20)
buttonDel.pack()
buttonIn=ttk.Button(memo, text="Insert", command=insert, width=20)
buttonIn.pack()
buttonHi=ttk.Button(memo, text="Highlight", command=highlight, width=20)
buttonHi.pack()
buttonAlDel=ttk.Button(memo, text="All Delete", command=aldel, width=20)
buttonAlDel.pack()
buttonMod=ttk.Button(memo, text="Modify", command=modi, width=20)
buttonMod.pack()
buttonCount=ttk.Button(memo, text="Num of Tasks", command=counting, width=20)
buttonCount.pack()

# mainloop()
memo.mainloop()