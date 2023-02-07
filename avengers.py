#남은조건: (1) 각 라운드 끝나고 방어력,체력,공격력 상승
#          (2) 적 겹치지 않기 
# character random choice
import random

#mem class
class Mem:
    def __init__(self, name, defense, attack, Hp):
        self.name=name
        self.defense=defense
        self.attack=attack
        self.Hp=Hp

members=[
    Mem("IronMan",50,70,100),
    Mem("Captain",50,60,100),
    Mem("Thor",20,90,100),
    Mem("Thanos",50,100,300)
]   

#character select
print("Please Select Number to Choose Your Character")
print("[0]: IronMan\n [1]: Captain\n [2]:Thor")
main=int(input("Select Number: "))

enemy=random.randint(0,2)
enemy1=enemy
count=3
while count>0:
    #round별 cha_info 변동
    if count==2:
        members[main].defense+=10
    elif count==1:
        members[main].defense+=10
        members[main].attack+=10
        members[main].Hp+=200
        enemy=3

    #select enemy
    if count>1:
        while enemy==main:
            if count==2:
                if enemy1==enemy:
                    pass
            enemy=random.randint(0,2)
    
    print(members[enemy].name)
    main_mana=members[main].Hp
    enemy_mana=members[enemy].Hp
    damage_main=members[enemy].attack-members[main].defense
    damage_enemy=members[main].attack-members[enemy].defense
    print(main_mana)

#condition of game over
    while main_mana>0 and enemy_mana>0:
        win_lose=random.randint(0,1)
        if win_lose == 0:
            print("You're attacked!")
            main_mana-=damage_main
            print("Your Hp:{}, Enemy Hp:{}".format(main_mana,enemy_mana))

        else:
            print("You attack!")
            enemy_mana-=damage_enemy
            print("Your Hp:{}, Enemy Hp:{}".format(main_mana,enemy_mana))
    
    if main_mana<=0:
        print("You Lose!")
        print("Game Over")
        break

    if enemy_mana<=0:
        count-=1
        if count==0:
            print("Finally You Win!")
            break
        question=input("Do wanna go to next stage?: ")
        if question.lower()!='yes':
            print("Quit this game")
            break
        while True:
            enemy=enemy1
            enemy=random.randint(0,2)
            if enemy==enemy1 or enemy==main:
                pass
            else:
                break
    
print("-The End-")


    



















