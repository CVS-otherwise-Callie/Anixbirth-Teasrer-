sorry the files are in XML form, they ARE rushed and uncompleted.

--PLEASE READ--

When you decide to make a room, remove the "<!--" from the top of the section and put it back on where you want to end the rooms you are going to do 

PLEASE check the amount of downloaders in the steam page, and then go down that many people x 3

IF that goes over the amount of rooms, use THIS python script to create new rooms:

insert how many rooms you want in the "for x in range"

# Online Python - IDE, Editor, Compiler, Interpreter
import random
lastnum = whatever room was last put + 1
for x in range(10):
  if random.randint(1, 3) == 3:
    room = random.randint(2, 10)
  else:
    room = 1
  if room == 10:
    print(f'    <room variant="{x + lastnum}" name="Community -" type="1" subtype="0" shape="{room}" width="26" height="14" difficulty="8" weight="1.0">')
    print(f'      <door exists="True" x="-1" y="3"/>')
    print(f'      <door exists="True" x="-1" y="10"/>')
    print(f'      <door exists="True" x="6" y="-1"/>')
    print(f'      <door exists="True" x="6" y="14"/>')
    print(f'      <door exists="True" x="13" y="3"/>')
    print(f'      <door exists="True" x="19" y="6"/>')
    print(f'      <door exists="True" x="19" y="14"/>')
    print(f'      <door exists="True" x="26" y="10"/>')
    print(f'    </room>')
    
  elif room ==9:
    print(f'    <room variant="{x + lastnum}" name="Community -" type="1" subtype="0" shape="{room}" width="26" height="14" difficulty="8" weight="1.0">')
    print(f'      <door exists="True" x="-1" y="10"/>')
    print(f'      <door exists="True" x="6" y="6"/>')
    print(f'      <door exists="True" x="6" y="14"/>')
    print(f'      <door exists="True" x="12" y="3"/>')
    print(f'      <door exists="True" x="19" y="-1"/>')
    print(f'      <door exists="True" x="19" y="14"/>')
    print(f'      <door exists="True" x="26" y="3"/>')
    print(f'      <door exists="True" x="26" y="10"/>')
    print(f'    </room>')
    
  elif room ==8:
    print(f'    <room variant="{x + lastnum}" name="Community -" type="1" subtype="0" shape="{room}" width="26" height="14" difficulty="8" weight="1.0">')
    print(f'	  <door exists="True" x="-1" y="3"/>')
    print(f'      <door exists="True" x="-1" y="10"/>')
    print(f'      <door exists="True" x="6" y="-1"/>')
    print(f'      <door exists="True" x="6" y="14"/>')
    print(f'      <door exists="True" x="19" y="-1"/>')
    print(f'      <door exists="True" x="19" y="14"/>')
    print(f'      <door exists="True" x="26" y="3"/>')
    print(f'      <door exists="True" x="26" y="10"/>')
    print(f'    </room>')
    
  elif room ==7:
    print(f'    <room variant="{x + lastnum}" name="Community -" type="1" subtype="0" shape="{room}" width="26" height="7" difficulty="8" weight="1.0">')
    print(f'	  <door exists="True" x="-1" y="3"/>')
    print(f'      <door exists="True" x="26" y="3"/>')
    print(f'    </room>')
  
  elif room ==6:
    print(f'    <room variant="{x + lastnum}" name="Community -" type="1" subtype="0" shape="{room}" width="26" height="7" difficulty="8" weight="1.0">')
    print(f'	  <door exists="True" x="-1" y="3"/>')
    print(f'      <door exists="True" x="6" y="-1"/>')
    print(f'      <door exists="True" x="6" y="7"/>')
    print(f'      <door exists="True" x="19" y="-1"/>')
    print(f'      <door exists="True" x="19" y="7"/>')
    print(f'      <door exists="True" x="26" y="3"/>')
    print(f'    </room>')
    
  elif room ==5:
    print(f'    <room variant="{x + lastnum}" name="Community -" type="1" subtype="0" shape="{room}" width="13" height="14" difficulty="8" weight="1.0">')
    print(f'	  <door exists="True" x="6" y="-1"/>')
    print(f'      <door exists="True" x="6" y="14"/>')
    print(f'    </room>')

  elif room ==4:
    print(f'    <room variant="{x + lastnum}" name="Community -" type="1" subtype="0" shape="{room}" width="13" height="14" difficulty="8" weight="1.0">')
    print(f'	  <door exists="True" x="-1" y="3"/>')
    print(f'      <door exists="True" x="-1" y="10"/>')
    print(f'      <door exists="True" x="6" y="-1"/>')
    print(f'      <door exists="True" x="6" y="14"/>')
    print(f'      <door exists="True" x="13" y="3"/>')
    print(f'      <door exists="True" x="13" y="10"/>')
    print(f'    </room>')
    
  elif room ==3:
    print(f'    <room variant="{x + lastnum}" name="Community -" type="1" subtype="0" shape="{room}" width="13" height="7" difficulty="8" weight="1.0">')
    print(f'	  <door exists="True" x="6" y="-1"/>')
    print(f'      <door exists="True" x="6" y="7"/>')
    print(f'    </room>')

  
  
  elif room == 2:
    print(f'    <room variant="{x + lastnum}" name="Community -" type="1" subtype="0" shape="{room}" width="13" height="7" difficulty="8" weight="1.0">')
    print(f'      <door exists="True" x="-1" y="3"/>')
    print(f'      <door exists="True" x="13" y="3"/>')
    print(f'    </room>')
    
  elif room == 1:
    print(f'    <room variant="{x + lastnum}" name="Community -" type="1" subtype="0" shape="{room}" width="13" height="7" difficulty="8" weight="1.0">')
    print(f'      <door exists="True" x="-1" y="3"/>')
    print(f'      <door exists="True" x="6" y="-1"/>')
    print(f'      <door exists="True" x="6" y="7"/>')
    print(f'      <door exists="True" x="13" y="3"/>')
    print(f'    </room>')