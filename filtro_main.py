from tkinter import *
from tkinter import font
from tkinter import messagebox
from tkinter import ttk
from tkinter.filedialog import askopenfilename
from PIL import Image
import numpy as np
import scipy.misc as smp
import os


def choose_file():
    global filename
    Tk().withdraw() 
    filename = askopenfilename()
    filename_selected_lbl.configure(text=filename)


def apply_filter():
    global filename
    img = Image.open(filename).convert('L')
    img.show()
    pix_val = list(img.getdata())

    i = 0
    for value in pix_val:
        if(value < 100):
            pix_val[i]="0"+str(value)
        i+=1
    file = open("img.txt","w") 
    file.write(str(pix_val).replace("[", "").replace("]", "")
      .replace(" ", "").replace(",", "").replace("'", ""))
    file.close()

    #os.system('./sharp')

    return

def see_results(width, heigth):
    see_sharp(width, heigth)
    see_oversharp(width, heigth)
    
    return

def see_sharp(width, heigth):
    img_pixels = []
    file = open("sharp.txt","r")
    img_txt = file.read()
    width_int = int(width)
    heigth_int = int(heigth)
    
    value = ""
    i = 0
    j = 0
    for value in img_txt:
        i += 1
        j += 1
        if(j==4):
            new_number = int(img_txt[i-4:i].strip("\x00")) - 2000
            if(new_number>255):
                new_number=255
            if(new_number<0):
                new_number=0
            img_pixels.append(new_number)
            j = 0

    data = np.array(img_pixels)
    data = data.reshape((heigth_int, width_int))
    image = Image.fromarray(data.astype(np.uint8), 'L')

    try:
        os.remove("img.txt")
        os.remove("sharp.txt")
        os.remove("sharp.png")
        os.remove("image.png")
    except:
        pass
    image.save("sharp.png")
    image.show()
    
    return

def see_oversharp(width, heigth):
    img_pixels = []
    file = open("oversharp.txt","r")
    img_txt = file.read()
    width_int = int(width)
    heigth_int = int(heigth)
    
    value = ""
    i = 0
    j = 0
    for value in img_txt:
        i += 1
        j += 1
        if(j==4):
            new_number = int(img_txt[i-4:i].strip("\x00")) - 2000
            if(new_number>255):
                new_number=255
            if(new_number<0):
                new_number=0
            img_pixels.append(new_number)
            j = 0

    data = np.array(img_pixels)
    data = data.reshape((heigth_int, width_int))
    image = Image.fromarray(data.astype(np.uint8), 'L')
    
    try:
        os.remove("oversharp.txt")
        os.remove("oversharp.png")
    except:
        pass

    image.save("oversharp.png")
    image.show()
    
    return
    

#########################################################

filename = ""
width = ""
height = ""

window = Tk()
window.title("Menú de inserción de datos del usuario")
window.geometry('450x400')
window.configure(background='blue')

Helvfont = font.Font(family="Helvetica", size=12, weight="bold")

filename_lbl = Label(window, text="Seleccione una imagen", font=Helvfont, fg='white', background='blue')
filename_lbl.place(x=95, y=15, anchor='center')

filename_selected_lbl = Label(window, text="", font=Helvfont, fg='white', background='blue')
filename_selected_lbl.place(x=200, y=85, anchor='center')

btn_file = Button(window, text="Abrir explorador", width=15,
             command=choose_file
             , background='white', fg='black')
btn_file.place(x=10, y=35)

size_lbl = Label(window, text="Tamaño de la imagen", font=Helvfont, fg='white', background='blue')
size_lbl.place(x=90, y=120, anchor='center')

width_lbl = Label(window, text="Ancho", font=Helvfont, fg='white', background='blue')
width_lbl.place(x=35, y=150, anchor='center')

height_lbl = Label(window, text="Alto", font=Helvfont, fg='white', background='blue')
height_lbl.place(x=25, y=220, anchor='center')

width_edittext = Entry(window, width=10)
width_edittext.place(x=10, y=165)

heigth_edittext = Entry(window, width=10)
heigth_edittext.place(x=10, y=235)

btn_filter = Button(window, text="Aplicar filtro", width=20,
             command=apply_filter
             , background='white', fg='black')
btn_filter.place(x=13, y=320)

btn_result = Button(window, text="Ver resultado", width=20,
             command=lambda:
                    see_results(width_edittext.get(), heigth_edittext.get())
             , background='white', fg='black')
btn_result.place(x=240, y=320)

window.mainloop()
