# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <codecell>

#By Santiago Beltran -- Apr. 27 -- Python Web Parser For BU Dining Menu Website


###IMPORT STATEMENTS... IMPORTANT
from html.parser import HTMLParser
import urllib.request
from lxml import html
from lxml import etree
import requests

# <codecell>

#Get menu section only. -- Get the Raw HTML from the site
def getSectioninHTML():    
    f = urllib.request.urlopen('http://www.bu.edu/dining/where-to-eat/residence-dining/warren-towers/menu/')
    rawHTML = (f.read().decode('utf-8'))
    #get the specials section from website
    
    startPoint = (rawHTML.find('<div class="dining-menu-meals">'))
    endPoint = (rawHTML.find('<ul class="menu-legend">'))
    
    rawHTML = rawHTML[startPoint:endPoint]
    
    return rawHTML

# <codecell>

#PARAM: B: Breakfast, L: Lunch, D:Dinner
#OUTPUT: Cleaned up code that includes only the breakfast|Lunch|Dinner sections of RAW HTML code. 
#If a meal does not exist, then returns 0.
def getMealSectioninHTML(section):
    
    #get all HTML
    rawHTML = getSectioninHTML()
    #get breakfast
    if(section == 'B'):
        startPoint = (rawHTML.find('<a name="breakfast"></a>'))
        endPoint = (rawHTML.find('<a name="lunch"></a>'))
        return rawHTML[startPoint:endPoint]
    #get lunch
    elif(section == 'L'):
        startPoint = (rawHTML.find('<a name="lunch"></a>'))
        endPoint = (rawHTML.find('<a name="dinner"></a>'))
        return rawHTML[startPoint:endPoint]
    #get dinner
    elif(section == 'D'):
        startPoint = (rawHTML.find('<a name="dinner"></a>'))
        #endPoint = (rawHTML.find('</div><div class="substation brickoven-station">'))
        return rawHTML[startPoint:]
    else:
        return 0

# <codecell>

#TEST THE Get Meal in a Section Code. UNCOMMENT TO TEST

#print (getMealSectioninHTML('D'))

# <codecell>

###################OLD DON'T USE:#################################################
#page = requests.get('http://www.bu.edu/dining/where-to-eat/residence-dining/warren-towers/menu/')

#Create a tree from the specified meal. 
tree = html.fromstring(getMealSectioninHTML('L'))

# Get the item category titles
categories = tree.xpath('//span[@class="item-title-name"]/text()')

# get item names and properties
#Get raw spedials of the day (in HTML)
specialHTML = ''
for elem in tree.xpath('//div[@class="specials"]'):
    #items = tree.xpath('//div[@class="specials"]')
    #prices = tree.xpath('//span[@class="item-price"]/text()')
    specialHTML = (etree.tostring(elem, pretty_print=True))

tree2 = html.fromstring(specialHTML)
items = tree.xpath('//span[@class="item-menu-name"]/text()')
Sargent = tree.xpath('//span[@class="sargent-icon menuitem-icon"]')
Vegan = tree.xpath('//span[@class="vegan-icon menuitem-icon"]')
Vegetarian = tree.xpath('//span[@class="vegetarian-icon menuitem-icon"]')
Gluten = tree.xpath('//span[@class="glutenfree-icon menuitem-icon"]')


    
print (categories)
print (items)
print (Sargent)
print (Vegan)
print (Vegetarian)
print (Gluten)

#THIS CODE IS NOT USED IN THE ACTUAL PARSING ENGINE, BUT WAS THE INITIAL RUN. DON'T DELETE. I THINK I CAN MAKE THIS CODE WORK TOO.

# <codecell>

#Input Parameters: catgID: categoryID [3 char: ACCEPTS: many, as defined]; mealID: meal Id [1 char: ONLY ACCEPTS: B,L,D]
#Output: Raw HTML for the selected category based on meal.

#Function Call Example (without angle brackets): getHTMLbyCategory(<Category Shorthand Identifier: 3 CHAR>,<Meal Identifier: 1 CHAR>)
def getHTMLbyCategory(catgID, mealID):
    #Get raw HTML that belongs to the mealID Section from input parameter 'mealID'. This calls another function 'getMealSectioninHTML', that gets HTML code from only Breakfast, Lunch, or Dinner.
    tree = html.fromstring(getMealSectioninHTML(mealID))
    
    #The tree is a node of elaments with a structure... basically view-source of a website, that tree... well that is what this one is too.
    
    #Switch/Case Statement Python Style
    #Get raw HTML furthur filtered based on Food Category Type from the input parameter 'catgID'
    if (catgID == 'BRI'):
        for elem in tree.xpath('//div[@class="station brickoven-station"]'):
            return (etree.tostring(elem, pretty_print=True))
    ####Example elif with comments explaining the format, rules, and operation.####
    #elif (else if) , check if the input parameter 'catgID' is equal to string 'DEL'. 'DEL' is programmer defined.
    #All catgID options must be unique to all the other catgIDs. I usually took the first 3 charaters in the station name. MAKE SURE IT'S UNIQUE
    elif (catgID == 'DEL'):
        #Just follow this format. It calls a function in the lxml library that gets HTML node where it finds a <div> element w/ the class="station deli-station"
        #How to get the station name and class id? Go to the menu, select a meal, and then view source. CTRL-F for <div class="inside container">... 
        ##### ...cont. Look at the <div class="station XXXX-station id=...>". Copy the entire class name with quotes and add it to the part after class in the example.
        ##### ...cont. Lastly give it a name above in (catgID = 'XXX') that is unique and relevant to the station name.
        for elem in tree.xpath('//div[@class="station deli-station"]'):
            #since there is only one node (also why it's important to be inside a meal -- Breakfast, Lunch, Dinner) return the node (plain HTML code). 
            return (etree.tostring(elem, pretty_print=True))
    #repeat...see above for explaination. 
    elif (catgID == 'EXH'):
        for elem in tree.xpath('//div[@class="station exhibitionsaute-station"]'):
            return (etree.tostring(elem, pretty_print=True))
    elif (catgID == 'HOM'):
        for elem in tree.xpath('//div[@class="station homezone-station"]'):
            return (etree.tostring(elem, pretty_print=True))
    elif (catgID == 'IMP'):
        for elem in tree.xpath('//div[@class="station impinger-station"]'):
            return (etree.tostring(elem, pretty_print=True))
    elif (catgID == 'INT'):
        for elem in tree.xpath('//div[@class="station international-station"]'):
            return (etree.tostring(elem, pretty_print=True))
    elif (catgID == 'MON'):
        for elem in tree.xpath('//div[@class="station mongoliangrill-station"]'):
            return (etree.tostring(elem, pretty_print=True))
    elif (catgID == 'ROT'):
        for elem in tree.xpath('//div[@class="station rotisserie-station"]'):
            return (etree.tostring(elem, pretty_print=True))
    elif (catgID == 'SAL'):
        for elem in tree.xpath('//div[@class="station saladbar-station"]'):
            return (etree.tostring(elem, pretty_print=True))
    elif (catgID == 'SNA'):    
        for elem in tree.xpath('//div[@class="station snacks-station"]'):
            return (etree.tostring(elem, pretty_print=True))
    elif (catgID == 'SOU'):
        for elem in tree.xpath('//div[@class="station soup-station"]'):
            return (etree.tostring(elem, pretty_print=True))
    elif (catgID == 'GRI'):
        for elem in tree.xpath('//div[@class="station grill-station"]'):
            return (etree.tostring(elem, pretty_print=True))
    elif (catgID == 'VEG'):
        for elem in tree.xpath('//div[@class="station vegandelights-station"]'):
            return (etree.tostring(elem, pretty_print=True))
    elif (catgID == 'WAF'): 
        for elem in tree.xpath('//div[@class="station waffles-station"]'):
            return (etree.tostring(elem, pretty_print=True))
    elif (catgID == 'BAK'):
        for elem in tree.xpath('//div[@class="station bakery-station"]'):
            return (etree.tostring(elem, pretty_print=True))
    #Add missing category identifiers here from other dining halls. ALL MUST BE UNIQUE. If it already exists above, it can not be added below.
    #Follow elif template for new categories and first example above.
    #### ADDITIONAL CATEGORIES HERE #####
    
    
    
    ### END OF ADDITIONAL CATEGORIES HERE #####
    
    #default. Error must be caught, return None. DO NOT EDIT THIS
    else:
        return None

# <codecell>

#Test code: This gives you the raw html for each category type of food for a lunch menu. Make sure to add any categories added later to the list.
# If the category is available, then it gives the RAW html Code. Else, give you ---- CATG XXXXX IS NOT AVAILABLE. Make sure that it actually...
#... is not avaluable and not that it's a logical error. 

def testSortingByCategoryRAW():
    categories = ['BRI', 'DEL', 'EXH', 'HOM', 'IMP', 'INT', 'MON', 'ROT', 'SAL', 'SNA', 'SOU', 'GRI', 'VEG', 'WAF']

    for item in categories:
        extractCode = getHTMLbyCategory(item, 'L')
        if (extractCode == None):
            print ("--------------- CATG " + item + " IS NOT AVAILABLE --------------")
        else:
            print (extractCode)

####UNCOMMENT LINE BELOW TO GET TEST OUTPUT####
#testSortingByCategoryRAW()

# <codecell>

#Gets the HTML code for the item block inside a meal. 
#Input Parameter: HTML Code [already inside a meal block].
#OUTPUT: HTML Code for just the items in that meal. 
def getItemHTML(code):
    #Setup a LXML Tree from the raw code.
    tree12 = html.fromstring(code)
    #Get the node where the <ul> class is equal to 'items'
    for elem1 in tree12.xpath('//ul[@class="items"]'):
        #Return the node (plain HTML code) of the <ul>...</ul> block
        return (etree.tostring(elem1, pretty_print=True))

# <codecell>

#Get all items in a category with properties. The good stuff.
#INPUT PARAMETERS: A valid catgID and mealID (what station category and what meal -- B,L,D)
def getItemsWithPropertiesFromCATG(catgID, mealID):
    
    #Save Raw HTML from category selection
    extractCode = getHTMLbyCategory(catgID, mealID)
    
    #Error Validation. If the menu does not have a section, then it return "N/A" for that section. This might change to a number for easire use later.
    if (extractCode == None):
        return "N/A";
    
    #Dictionary of items, KEY: item name, DEFINITION: Properties
    itemDict = {}
    
    #USLESS CODE, BUT I'M SCARED TO COMPLETELY ERASE IT...So keep it.
    #Get clean tree (LXML) from raw HTML
    #tree = html.fromstring(extractCode)
    
    #Get all items, still in raw HTML, but less
    #items = tree.xpath('//span[@class="item-menu-name"]/text()')
    ##### END OF USELESS CODE #####
    
    #Get raw HTML, but only the items. 
    #Basically, we're getting to the really pure stuff about now, but not enough to sell it yet.
    itemsExtractedCode = getItemHTML(extractCode)
    #Get clean tree of items html only. It just keeps getting purer -- A browser would like it, but not good enough for human use.
    itemTree = html.fromstring(itemsExtractedCode)
    
    ### ANOTHER SET OF USELESS CODE... a remittance of my child node code days... 1childDeep, 2childDeep, 3childDeep, limbo
    #Get childs (li) and the id
    #for itemID in itemTree.iterchildren():
    #    child = (itemID.getchildren())
    #    print (itemID.values())
    ##### END OF USELESS CODE #####

    #Get a list of elements where the class name is equal to 'item-icons' :: Here we get the Special Icon names, Vegan|Sargent|Vg|Glut
    elementList = itemTree.find_class('item-icons')
    
    #Interate over that elementList. How it looks [[element li 0x000000],[element li 0x000000],[....]]
    # and visually:
    #   <a href="#ingredients-1973270909" class="" rel="prettyPhoto">  *** SECOND PARENT  -- THE OMG THIS IS AMAZING STUFF (NAME & Image ID)
    #                 ^^^^^^
    #                  ||||
    #   <span class="item-inner-grid">  ***  FIRST PARENT -- THE WTF, WHY ARE YOU HERE STUFF
    #                ^^^^^^
    #                 ||||
    #       <span class="item-icons">  **** YOU ARE HERE -- THE GOOD STUFF (The icon IDs)
    # (See why there was child-ception earlier.)
    for element in elementList:
        #Setup a list (like a vector in C++) for all the property info
        propertyList = []
        #Look above for that these element variables mean
        parent1 = element.getparent()
        parent2 = parent1.getparent()
        #Get name of food item
        itemNameElement = parent2.find_class('item-menu-name') #Told you the second parent is were it's at! ;)
        #This returns a list but since every item can only have one name, we just get the first value of the list.
        itemName = itemNameElement[0].text_content()
        #Go back two elements [Parent 2] again to get the image ID
        parent2Values = parent2.values()
        #Go back down to the you are here point and get special types (Sargent, Vegan, etc.) & Save to list with append
        propertyList.append(element.text_content())
        #Get the ID (for image) & Save to list. Again only one image so we get the first element in the list.
        propertyList.append(parent2Values[0])
        #Create a dictionary item with the key of the itemName and the definition of the property list.
        itemDict[itemName] = propertyList
        #get out of the current item. Not needed, but a just in case statement.
        continue 
        #Words of Inspiration:
        #IT WORKED!!!! 
    
    
    #####USELESS CODE -- I was trying to figuru out where the well I was in the child/parent mess. ########
    #for element in itemTree.getiterator():
     
    #    if (element.tag == 'ul' or element.tag == 'li'):
    #        continue
    #    else:
    #        print (element.tag, '-', element.values())
    #        print ("YOU FOUND ME")
    #    for interChild in child:
    #        print (interChild.values())
    ############## END OF USELESS CODE ###############
    
    

    #Return a dictionary of every item on the menu for that particular meal and category. :)
    return itemDict
    

# <codecell>

#Test Code to read the dictionary at every category for lunch. Includes some styling for readability.

def testItemDictionaryWithPrinting():
    categories = ['BRI', 'DEL', 'EXH', 'HOM', 'IMP', 'INT', 'MON', 'ROT', 'SAL', 'SNA', 'SOU', 'GRI', 'VEG', 'WAF']

    for CATtype in categories:
        print (getItemsWithPropertiesFromCATG(CATtype, 'L'))
        print ("-------------------------------------------------")
###RUN THE LINE BELOW TO TEST THE PROGRAM:####
testItemDictionaryWithPrinting()

# <codecell>

# LIFE IS GOOD!

